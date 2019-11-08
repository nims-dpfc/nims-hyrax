require 'rails_helper'

RSpec.describe CommonMethods do
  let(:test_class) { Struct.new(:id, :parent) { include CommonMethods } }

  context 'new record' do
    subject { test_class.new('#new', 'parent') }

    it 'is a new record' do
      expect(subject.new_record?).to be true
    end

    it 'is not persisted' do
      expect(subject.persisted?).to be false
    end

    it 'has a final_parent' do
      expect(subject.final_parent).to eql 'parent'
    end
  end

  context 'existing record' do
    subject { test_class.new('existing', 'parent') }

    it 'is not a new record' do
      expect(subject.new_record?).to be false
    end

    it 'is persisted' do
      expect(subject.persisted?).to be true
    end

    it 'has a final_parent' do
      expect(subject.final_parent).to eql 'parent'
    end
  end
end
