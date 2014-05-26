$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "efflux/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "efflux"
  s.version     = Efflux::VERSION
  s.authors     = ["Joe Bellus"]
  s.email       = ["joe@confluentlight.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Efflux."
  s.description = "TODO: Description of Efflux."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.1"
  s.add_dependency 'coffee-rails'
  s.add_dependency 'sass'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"

end
