require 'rails_helper'

RSpec.describe HyraxHelper, :type => :helper do
  describe '#available_translations' do
    it 'returns available translations' do
      expect(helper.available_translations).to eql({"en"=>"English"})
    end
  end

  it 'has no singleton methods' do
    expect(subject.singleton_methods).to be_empty
  end
end
