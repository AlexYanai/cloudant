# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudant/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudant"
  spec.version       = Cloudant::VERSION
  spec.authors       = ["Alex Yanai"]
  spec.email         = ["yanai.alex@gmail.com"]

  spec.summary       = %q{Ruby wrapper to access a Cloudant instance.}
  spec.description   = %q{A ruby interface to access a Cloudant database.}
  spec.homepage      = "https://github.com/AlexYanai/cloudant"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "dotenv", "~> 2.1"
  spec.add_development_dependency "webmock", "~> 2.1"
  spec.add_development_dependency "rest-client", "~> 2.0"
end
