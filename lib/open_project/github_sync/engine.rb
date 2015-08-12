# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'

module OpenProject::GithubSync
  class Engine < ::Rails::Engine
    engine_name :openproject_github_sync

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-github_sync',
             :author_url => 'http://finn.de',
             :requires_openproject => '>= 3.0.0pre13'

  end
end
