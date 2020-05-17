$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "download/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "download"
  s.version     = Download::VERSION
  s.authors     = ["Wei Zhu"]
  s.email       = ["yesmeck@gmail.com"]
  s.homepage    = "http://git.che3bao.com/autobots/prime-server"
  s.summary     = "Download page of prime"
  s.description = "Just the download page"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"
end
