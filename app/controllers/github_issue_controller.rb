class GithubIssueController < ApplicationController
  STATUS_MAP = {
    'dev - in progress' => 6,
    'dev - done' => 11
  }
  protect_from_forgery except: :issue_event
  before_filter :check_security
  def issue_event
    project = Project.find(params[:project_id])
    user = User.find(Rails.env.production? ? 31 : 6)
    puts user.inspect
    User.current = user
    action = request.request_parameters['action']
    title = params[:issue][:title]
    github_number = params[:issue][:number]
    body = params[:issue][:body]

    if action == 'opened'
      package = project.work_packages.new

      package.subject = title
      package.description = body + "\n\n Created by Github User: #{params[:issue][:user][:login]}"
      package.author = User.first
      package.type = Type.where(name: 'Bug').first
      custom_field_key = Rails.env.production? ? '1' : '5'
      package.custom_field_values= { custom_field_key => github_number.to_s }
      package.save
    elsif action == 'closed'
      package = CustomValue.where(value: '129', custom_field_id: 5).first.customized
      package.status = Status.where(name: 'Closed', is_closed: true).first
      package.save
      puts package.errors.inspect
    elsif action == 'labeled'
      package = CustomValue.where(value: '129', custom_field_id: 5).first.customized
      puts "HERE NOW"

      labels = params[:issue][:labels].collect { |label| label[:name] }
puts labels.inspect
      status_id = STATUS_MAP.select { |key, _| labels.include?(key) }.values.first
puts status_id.inspect
      unless status_id.nil?
        puts "HERE NOW"
        puts status_id.inspect
        puts Status.find(status_id).inspect
        package.status_id = status_id
        puts package.save
        puts package.errors.inspect
      end

    end
    render text: 'OK'
  end


  private

  def check_security
    request.body.rewind
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), OpenProject::Configuration['github_callback_secret'], request.body.read)
    head 500 unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
