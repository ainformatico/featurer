# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'featurer/version'

Gem::Specification.new do |spec|
  spec.name          = 'featurer'
  spec.version       = Featurer::VERSION
  spec.authors       = ['Alejandro El Informatico']
  spec.email         = ['aeinformatico@gmail.com']
  spec.summary       = %q{Easy feature flag for your project}
  spec.description   = %q{Easy feature flag for your project shipped with Redis support}
  spec.homepage      = 'https://github.com/ainformatico/featurer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'redis', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
