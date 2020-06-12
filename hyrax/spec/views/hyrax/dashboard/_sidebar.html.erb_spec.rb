# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/dashboard/_sidebar.html.erb', type: :view do
  let(:user) { FactoryBot.build(:user) }
  let(:can_result) { false }

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(user)
    assign(:user, user)
    allow(view).to receive(:can?).with(:read, :admin_dashboard).and_return(can_result)
    allow(view).to receive(:can?).with(:manage_any, AdminSet).and_return(can_result)
    allow(view).to receive(:can?).with(:review, :submissions).and_return(can_result)
    allow(view).to receive(:can?).with(:manage, User).and_return(can_result)
    allow(view).to receive(:can?).with(:update, :appearance).and_return(can_result)
    allow(view).to receive(:can?).with(:manage, Hyrax::Feature).and_return(can_result)
    allow(view).to receive(:can?).with(:manage, Sipity::WorkflowResponsibility).and_return(can_result)
    allow(view).to receive(:can?).with(:manage, :collection_types).and_return(can_result)
  end

  context 'with any user' do
    before do
      render
    end
    subject { rendered }

    it { is_expected.not_to have_link t('hyrax.admin.sidebar.collections') }
    it { is_expected.to have_link t('hyrax.admin.sidebar.works') }
  end

  context 'with a user who can read the admin dashboard' do
    let(:can_result) { true }

    before do
      render
    end
    subject { rendered }

    it { is_expected.to have_link t('hyrax.admin.sidebar.collections') }
    it { is_expected.to have_link t('hyrax.admin.sidebar.works') }
  end
end
