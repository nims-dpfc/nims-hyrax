# Generated via
#  `rails generate hyrax:work Publication`
require 'rails_helper'

RSpec.describe Hyrax::PublicationsController do
  describe 'GET #show' do
    let(:dataset) { create(:dataset, :open) }

    context 'with valid locale' do
      it 'returns a success response' do
        get :show, params: { id: dataset.id, locale: 'en' }
        expect(response).to be_successful
      end
    end

    context 'with invalid locale' do
      it 'returns a success response' do
        get :show, params: { id: dataset.id, locale: 'zzz' }
        expect(response).to be_successful
      end
    end
  end
end
