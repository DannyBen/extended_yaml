require 'spec_helper'
require 'yaml'

describe ExtendedYAML do
  describe '::load' do
    subject { ExtendedYAML.load 'examples/master.yml' }

    it "loads and evaluates a YAML file" do
      expect(subject.to_yaml).to match_fixture('examples/master.yml')
    end

    context "when a different key is provided" do
      subject { ExtendedYAML.load 'examples/different_key.yml', key: 'include' }
      it "uses that key to load additional YAML files" do
        expect(subject.to_yaml).to match_fixture('examples/different_key.yml')
      end
    end
  end
end
