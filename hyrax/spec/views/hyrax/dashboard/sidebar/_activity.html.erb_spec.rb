# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/dashboard/sidebar/_activity.html.erb', type: :view do
  let(:user) { FactoryBot.build(:user) }
  let(:can_result) { false }

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(user)
    assign(:user, user)
  end

  context 'with any user' do
    before do
      render partial: 'hyrax/dashboard/sidebar/activity', locals: {menu: Hyrax::MenuPresenter.new(view)}
    end
    subject { rendered }

    it { is_expected.to have_link 'Profile', href: "/dashboard/profiles/#{user.user_identifier}" }
  end
end
