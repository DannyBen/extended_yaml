require 'spec_helper'
require 'yaml'

describe ExtendedYAML do
  describe '::load' do
    subject { described_class.load 'examples/master.yml' }

    it "loads and evaluates a YAML file" do
      expect(subject.to_yaml).to match_fixture('master.yml')
    end

    context "when a different key is provided" do
      subject { described_class.load 'examples/different_key.yml', key: 'include' }

      it "uses that key to load additional YAML files" do
        expect(subject.to_yaml).to match_fixture('different_key.yml')
      end
    end

    context "when using wildcards" do
      subject { described_class.load 'examples/wildcard.yml' }

      it "imports all files" do
        expect(subject.to_yaml).to match_fixture('wildcard.yml')
      end
    end
  end
end
