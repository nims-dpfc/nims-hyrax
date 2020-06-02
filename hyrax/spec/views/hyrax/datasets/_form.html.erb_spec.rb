# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/datasets/_form.html.erb', type: :view do
  let(:work) { Dataset.new }
  let(:ability) { double }
  let(:user) { FactoryBot.build(:user) }

  let(:form) do
    Hyrax::DatasetForm.new(work, ability, controller)
  end

  before do
    view.lookup_context.prefixes += ['hyrax/base']
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
  end

  describe 'tabs' do
    it 'shows the relationships tab' do
      render
      expect(rendered).to have_selector('#relationships[role="tabpanel"]')
      expect(rendered).to have_selector('#metadata[role="tabpanel"]')
      expect(rendered).to have_selector('#files[role="tabpanel"]')
      expect(rendered).to have_selector('#share[data-param-key="dataset"]')
    end
  end
end
