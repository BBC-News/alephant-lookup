# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alephant/lookup/version'

Gem::Specification.new do |spec|
  spec.name          = "alephant-lookup"
  spec.version       = Alephant::Lookup::VERSION
  spec.authors       = ["BBC News"]
  spec.email         = ["D&ENewsFrameworksTeam@bbc.co.uk"]
  spec.summary       = "Lookup a location in S3 using DynamoDB."
  spec.homepage      = "https://github.com/BBC-News/alephant-lookup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "listen", "<= 3.0.8" # required by Guard, but newer versions break our version of JRuby

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "aws-sdk-dynamodb"
  spec.add_runtime_dependency "alephant-logger"
  spec.add_runtime_dependency "alephant-support"

  spec.add_runtime_dependency "dalli"
  spec.add_runtime_dependency "crimp"
end
