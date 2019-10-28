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

  # @param [Hash] data the data structure, possibly with 'extends' array
  # @return [Hash] the merged data
  def resolve_extends(data)
    extra_files = data.delete key
    return data unless extra_files

    extra_files = expand_file_list extra_files

    extra_files.each do |path|
      data.deep_merge! self.class.new(path).result
    end

    data
  end

  # Receives a string or an array of strings, each representing an acceptable
  # path definition. Each definition may be with or without a file etxension,
  # and may be a glob pattern. The resulting array will be a normalized list
  # of full paths.
  #
  # @param [Array, String] files one or more path definitions
  # @return [Array] a normalized list of absolute paths
  def expand_file_list(files)
    list = []
    files = [files] unless files.is_a? Array

    files.each do |path|
      list += expand_path path
    end

    list
  end

  # @param [String] path the path to the YAML file, with or without extension.
  #   May include a glob pattern wildcard.
  # @return [Array] one or more absolute paths.
  def expand_path(path)
    path += extension unless path.end_with? extension
    path = File.expand_path path, base_dir
    path.include?('*') ? Dir[path] : [path]
  end
end
