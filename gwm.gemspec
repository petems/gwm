# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gwm/version'

Gem::Specification.new do |gem|
  gem.name          = 'gwm'
  gem.version       = Gwm::VERSION
  gem.authors       = ['Peter Souter']
  gem.email         = ['webmaster@petersouter.xyz']
  gem.description   = 'A command line tool for managing watching of repos on Github.'
  gem.summary       = 'A command line tool for managing watching of repos on Github.'
  gem.homepage      = 'https://github.com/petems/gwm'

  gem.files                 = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables           = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths         = ['lib']
  gem.required_ruby_version = '>= 2.4'

  gem.add_dependency 'thor', '0.18.1'
  gem.add_dependency 'octokit', '4.13.0'
  gem.add_dependency 'ibsciss-middleware', '0.4.2'
  gem.add_dependency 'faraday_middleware', '0.12.2'
  gem.add_dependency 'faraday', '0.15.4'
  gem.add_dependency 'hashie', '3.5.5'
  gem.add_dependency 'activesupport', '4.2.9'

  gem.add_development_dependency 'rake', '12.0.0'
  gem.add_development_dependency 'rspec-core', '3.8.0'
  gem.add_development_dependency 'rspec-expectations', '3.8.2'
  gem.add_development_dependency 'rspec-mocks', '3.8.0'
  gem.add_development_dependency 'webmock', '3.4.2'
  gem.add_development_dependency 'simplecov', '0.14.1'
  gem.add_development_dependency 'simplecov-console', '0.4.2'
  gem.add_development_dependency 'coveralls', '0.7.2'
  gem.add_development_dependency 'aruba', '0.8.1'
  gem.add_development_dependency 'pry', '0.10.4'
  gem.add_development_dependency 'rb-readline', '0.5.4'
  gem.add_development_dependency 'vcr', '3.0.3'
  gem.add_development_dependency 'cucumber', '2.4.0'
  gem.add_development_dependency 'rubocop', '0.49.1'
  gem.add_development_dependency 'rubocop-rspec', '1.15.1'
  gem.add_development_dependency 'license_finder', '3.0.0'
  gem.add_development_dependency 'github_changelog_generator'

end
