require 'rails_helper'

RSpec.describe Ability do
  let(:ability) { Ability.new(user) }

  describe 'everyone_can_create_dataset' do
    subject { ability.everyone_can_create_dataset }

    context 'guest user' do
      let(:user) { create(:user, :guest) }
      it { is_expected.to be_nil }
    end

    context 'general user' do
      let(:user) { create(:user) }
      it { is_expected.to eql [::Dataset] }
    end

    context 'admin user' do
      let(:user) { create(:user, :admin )}
      it { is_expected.to eql [::Dataset] }
    end
  end

  describe 'everyone_can_create_publication' do
    subject { ability.everyone_can_create_publication }

    context 'guest user' do
      let(:user) { create(:user, :guest) }
      it { is_expected.to be_nil }
    end

    context 'general user' do
      let(:user) { create(:user) }
      it { is_expected.to eql [::Publication] }
    end

    context 'admin user' do
      let(:user) { create(:user, :admin )}
      it { is_expected.to eql [::Publication] }
    end
  end
end
