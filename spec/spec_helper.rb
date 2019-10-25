require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

RSpec.configure do |config|
  config.include Colsole
  config.fixtures_path = File.expand_path 'approvals', __dir__  
end

ENV['TTY'] = 'on'
