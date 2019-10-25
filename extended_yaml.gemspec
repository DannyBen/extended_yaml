lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'extended_yaml/version'

Gem::Specification.new do |s|
  s.name        = 'extended_yaml'
  s.version     = ExtendedYAML::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Load YAML files that merge other YAML files"
  s.description = "Load YAML files that deep merge other YAML files"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.homepage    = 'https://github.com/dannyben/extended_yaml'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.3.0"
end
