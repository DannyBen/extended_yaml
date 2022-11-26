require 'spec_helper'
require 'yaml'

describe ExtendedYAML do
  describe '::load' do
    subject { described_class.load 'examples/master.yml' }

    it 'loads and evaluates a YAML file' do
      expect(subject.to_yaml).to match_approval('master.yml')
    end

    # Ruby 3.1 / Psych 4 issue https://bugs.ruby-lang.org/issues/17866
    context 'when the YAML file contains anchors' do
      subject { described_class.load 'spec/fixtures/anchors.yml' }

      it 'loads and evaluates a YAML file' do
        expect(subject.to_yaml).to match_approval('anchors.yml')
      end
    end

    # Ruby < 3.1
    context 'when YAML does not respond to #unsafe_load' do
      it 'loads and evaluates a YAML file' do
        allow(YAML).to receive(:unsafe_load).and_raise(NoMethodError)
        expect(subject.to_yaml).to match_approval('master.yml')
      end
    end

    context 'when there are ERB tags in the extends tag' do
      subject { described_class.load 'examples/environment.yml' }

      before { ENV['ENVIRONMENT'] = 'production' }
      after  { ENV['ENVIRONMENT'] = nil }

      it 'evaluates the ERB before extending' do
        expect(subject.to_yaml).to match_approval('environment.yml')
      end
    end

    context 'when a different key is provided' do
      subject { described_class.load 'examples/different_key.yml', key: 'include' }

      it 'uses that key to load additional YAML files' do
        expect(subject.to_yaml).to match_approval('different_key.yml')
      end
    end

    context 'when using wildcards' do
      subject { described_class.load 'examples/wildcard.yml' }

      it 'imports all files' do
        expect(subject.to_yaml).to match_approval('wildcard.yml')
      end
    end

    context 'with an invalid path' do
      subject { described_class.load 'no-such-file.yml' }

      it 'raises Errno::ENOENT' do
        expect { subject }.to raise_error(Errno::ENOENT, /No such file or directory/)
      end
    end

    context 'with an empty file' do
      subject { described_class.load 'spec/fixtures/empty.yml' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
