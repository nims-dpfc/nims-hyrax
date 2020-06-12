# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'hyrax/base/_show_actions.html.erb', type: :view do
  let(:presenter) { Hyrax::WorkShowPresenter.new(solr_document, ability) }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:attributes) { { 'has_model_ssim' => ['Publication'], :id => '0r967372b' } }
  let(:ability) { double }

  before do
    allow(ability).to receive(:can?).with(:create, FeaturedWork).and_return(false)
    allow(presenter).to receive(:show_deposit_for?).with(anything).and_return(true)
    allow(presenter).to receive(:editor?).and_return(true)
  end

  context 'as a registered user' do
    it 'shows edit / delete / Add to collection links' do
      render 'hyrax/base/show_actions', presenter: presenter

      expect(rendered).to have_link 'Edit'
      expect(rendered).to have_link 'Delete'
      expect(rendered).not_to have_link 'Add to collection'
      expect(rendered).not_to have_button 'Add to collection'
    end
  end
end
