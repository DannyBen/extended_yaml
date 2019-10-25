require 'extended_yaml/deep_merge'
require 'erb'
require 'yaml'

class ExtendedYAML
  using DeepMerge
  attr_reader :file, :key

  # @param [String] file path to YAML file
  # @param [String] key YAML key to use for loading files
  # @return [Hash, Array] the parsed YAML
  def self.load(file, key: 'extends')
    new(file, key: key).result
  end

  def initialize(file, key: 'extends')
    @file, @key = file, key
  end

  # @return [Hash, Array] the parsed YAML
  def result
    data = ::YAML.load evaluate
    resolve_extends data
  end

  # @return [String] the YAML string, with evaluated and ERB
  def evaluate
    ERB.new(File.read file).result
  end

private

  def extension
    @extension ||= File.extname file
  end

  def base_dir
    @base_dir ||= File.dirname file
  end

  # @param [Hash] data structure, possibly with 'extends' array
  # @return [Hash] the merged data
  def resolve_extends(data)
    extra_files = data.delete key
    return data unless extra_files

    extra_files = [extra_files] unless extra_files.is_a? Array

    extra_files.each do |extra_file|
      extra_file = extra_file + extension unless extra_file.end_with? extension
      path = File.expand_path extra_file, base_dir
      data.deep_merge! self.class.new(path).result
    end

    data
  end
end
