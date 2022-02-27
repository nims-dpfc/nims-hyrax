# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/batch_uploads/_form.html.erb', type: :view do
  let(:work) { Publication.new }
  let(:ability) { double('ability', current_user: user) }
  let(:user) { FactoryBot.build(:user) }

  let(:form) do
    Hyrax::Forms::BatchUploadForm.new(work, ability, controller)
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
    end
  end
end
