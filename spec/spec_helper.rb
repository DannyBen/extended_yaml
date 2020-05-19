require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

ENV['TTY'] = 'on'

RSpec.configure do |config|
  config.include Colsole
end

