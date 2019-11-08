require 'rails_helper'

RSpec.describe Work do

  describe 'title' do
    context 'valid title' do
      subject { build(:work, title: ['Foo Bar']) }
      it { is_expected.to be_valid }
      it { expect(subject.title).to match_array ['Foo Bar'] }
    end

    context 'missing title' do
      subject { build(:work, title: nil) }
      it { is_expected.to_not be_valid }
    end
  end
end
