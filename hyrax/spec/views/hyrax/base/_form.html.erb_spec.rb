# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/base/_form.html.erb', type: :view do
  let(:work) { Publication.new }
  let(:ability) { double }
  let(:user) { FactoryBot.build(:user) }

  let(:form) do
    Hyrax::PublicationForm.new(work, ability, controller)
  end

  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
  end

  describe 'tabs' do
    it 'does not show the relationships tab' do
      render
      expect(rendered).to have_selector('#relationships[role="tabpanel"]')
      expect(rendered).to have_selector('#metadata[role="tabpanel"]')
      expect(rendered).to have_selector('#files[role="tabpanel"]')
      expect(rendered).to have_selector('#share[data-param-key="publication"]')
    end
  end
end
