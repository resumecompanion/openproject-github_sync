# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/github_sync/version'
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-github_sync"
  s.version     = OpenProject::GithubSync::VERSION
  s.authors     = "Finn GmbH"
  s.email       = "info@finn.de"
  s.homepage    = "https://community.openproject.org/projects/github-sync"  # TODO check this URL
  s.summary     = 'OpenProject Github Sync'
  s.description = 'test'
  s.license     = 'MIT' # e.g. "MIT" or "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", "~> 3.2.14"
end
