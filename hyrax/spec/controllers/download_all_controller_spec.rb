require 'rails_helper'
require 'devise'

RSpec.describe DownloadAllController, type: :controller do
  include Devise::Test::ControllerHelpers
  routes { Rails.application.routes }

  describe 'GET #show' do
    let(:user) { create(:user) } # not used yet!
    let(:file_set) { create(:file_set) }
    let(:dataset) { create(:dataset, members: [file_set]) }

    before do
      allow(subject).to receive(:authorize_download!).and_return(true)
    end

    context 'with file_sets' do
      before do
        CharacterizeJob.perform_now(file_set, file_set.original_file.id)
      end

      context 'request application/zip' do
        it 'returns a success response' do
          get :show, params: { id: dataset.id, format: :zip }
          expect(response).to be_successful
          expect(File.exist?('/tmp/test-0151_Dataset.zip')).to be_truthy
        end
      end

      context 'request anything other than application/zip' do
        it 'returns a failed response' do
          get :show, params: { id: dataset.id, format: :html }
          expect(response).not_to be_successful
        end
      end
    end

    context 'without file_sets' do
      let(:dataset) { create(:dataset) }

      context 'request application/zip but without filesets' do
        it 'returns a failed response' do
          get :show, params: { id: dataset.id, format: :zip }
          expect(response).not_to be_successful
        end
      end
    end
  end
end
