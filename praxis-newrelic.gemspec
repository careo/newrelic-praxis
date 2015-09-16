lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'praxis-newrelic/version'

Gem::Specification.new do |spec|
  spec.name          = "praxis-newrelic"
  spec.version       = Praxis::NewRelic::VERSION
  spec.authors = ["Josep M. Blanquer","Dane Jensen"]
  spec.summary       = %q{NewRelic plugin for Praxis.}
  spec.email = ["blanquer@gmail.com","dane.jensen@gmail.com"]

  spec.homepage = "https://github.com/rightscale/praxis-newrelic"
  spec.license = "MIT"
  spec.required_ruby_version = ">=2.1"

  spec.require_paths = ["lib"]
  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_runtime_dependency 'praxis', [">= 0"]
  spec.add_runtime_dependency 'praxis-blueprints', [">= 0"]
  spec.add_runtime_dependency 'praxis-mapper', [">= 0"]

  spec.add_runtime_dependency 'newrelic_rpm', [">= 3"]
  spec.add_runtime_dependency 'activesupport', [">= 3"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 0"

  spec.add_development_dependency'guard', ["~> 2"]
  spec.add_development_dependency'guard-rspec', [">= 0"]
  spec.add_development_dependency'rspec', ["< 2.99"]
  spec.add_development_dependency'pry', ["~> 0"]
  spec.add_development_dependency'pry-byebug', ["~> 1"]
  spec.add_development_dependency'pry-stack_explorer', ["~> 0"]
  spec.add_development_dependency'fuubar', ["~> 1"]
end
