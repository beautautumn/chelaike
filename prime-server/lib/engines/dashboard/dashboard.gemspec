$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dashboard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dashboard"
  s.version     = Dashboard::VERSION
  s.authors     = ["Darmody"]
  s.email       = ["eterlf41@gmail.com"]
  s.homepage    = "http://git.che3bao.com/autobots/prime-server"
  s.summary     = "The dashboard of Prime"
  s.description = "Manage and analyze data in the dark."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "pundit"
  s.add_dependency "jquery-rails"
  s.add_dependency "kaminari"
  s.add_dependency "sass-rails"
  s.add_dependency "ransack"
  s.add_dependency "ipa_reader"
  s.add_dependency "rubyzip", ">= 1.0.0"
  s.add_dependency "zip-zip"

  s.add_dependency "carrierwave-aliyun", "~> 0.3.6"
  s.add_dependency "rest-client"
end
