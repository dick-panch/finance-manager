# $:.push File.expand_path("../lib", __FILE__)
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require "finance_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "finance_manager"
  s.version     = FinanceManager::VERSION
  s.authors     = ["dick"]
  s.email       = ["dick-panch@gmail.com"]
  s.homepage    = "http://www.dipak-panchal.in"
  s.summary     = "Summary of Finance Manager"
  s.description = "Description of Finance Manager"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "5.1.2"
  s.add_development_dependency "pg", '~> 0.18'
  s.add_dependency 'devise', '4.3.0'
end
