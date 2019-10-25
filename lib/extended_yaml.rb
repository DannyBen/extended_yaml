require 'extended_yaml/deep_merge'
require 'erb'
require 'yaml'

if ENV['BYEBUG']
  require 'byebug'
  require 'lp'
end

class ExtendedYAML
  using DeepMerge
  attr_reader :file

  # Returns the parsed result hash
  def self.load(file)
    new(file).result
  end

  def initialize(file)
    @file = file
  end

  # Returns the parsed result hash
  def result
    data = ::YAML.load evaluate
    resolve_extends data
  end

  # Returns the YAML string, with evaluated !includes and ERB
  def evaluate
    text = File.read file
    text = evaluate_includes text
    ERB.new(text).result
  end

private

  def extension
    @extension ||= File.extname file
  end

  def base_dir
    @base_dir ||= File.dirname file
  end

  # Accepts a hash data, possibly with 'extends' array, merges the data from 
  # the extend source, and deletes the extends key.
  # Returns the merged hash data.
  def resolve_extends(data)
    extra_files = data.delete 'extends'
    return data unless extra_files

    extra_files = [extra_files] unless extra_files.is_a? Array

    extra_files.each do |extra_file|
      extra_file = extra_file + extension unless extra_file.end_with? extension
      path = File.expand_path extra_file, base_dir
      data.deep_merge! self.class.new(path).result
    end

    data
  end

  # Replaces all !include directives
  def evaluate_includes(text)
    result = text.dup
    text.scan /^(!include (.*))/ do |match, file|
      path = File.expand_path("#{file}#{extension}", base_dir)
      result.sub! match, self.class.new(path).evaluate
    end
    result
  end
end
