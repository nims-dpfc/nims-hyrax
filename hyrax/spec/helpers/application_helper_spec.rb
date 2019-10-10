require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do

  it 'has no instance methods' do
    expect(subject.public_instance_methods).to be_empty
  end

  it 'has no singleton methods' do
    expect(subject.singleton_methods).to be_empty
  end
end
