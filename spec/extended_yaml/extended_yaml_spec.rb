require 'spec_helper'
require 'yaml'

describe 'examples' do
  subject { ExtendedYAML.load 'examples/master.yml' }

  it "evaluates properly" do
    expect(subject.to_yaml).to match_fixture('examples/master.yml')
  end  
end
