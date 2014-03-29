# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/azure_version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-azure'
  spec.version       = Kitchen::Driver::AZURE_VERSION
  spec.authors       = ['Aaron Qian']
  spec.email         = ['aq1018@gmail.com']
  spec.summary       = %q{A Test Kitchen Driver for Windows Azure.}
  spec.description   = %q{A Test Kitchen Driver for Windows Azure.}
  spec.homepage      = 'https://github.com/aq1018/kitchen-azure'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'test-kitchen', '~> 1.0'
  spec.add_dependency 'azure', '~> 0.6.2'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'tailor'
  spec.add_development_dependency 'countloc'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
