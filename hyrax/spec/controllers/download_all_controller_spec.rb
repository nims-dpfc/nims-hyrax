require 'rails_helper'
require 'devise'

RSpec.describe DownloadAllController, type: :controller do
  include Devise::Test::ControllerHelpers
  routes { Rails.application.routes }

  describe 'GET #show' do
    let(:file_set) { create(:file_set) }
    let(:dataset) { create(:dataset, members: [file_set]) }

    context 'with public file_set' do
      before do
        allow(subject).to receive(:authorize_download!).and_return(true)
        allow(subject).to receive(:available_file_set_ids).and_return([file_set.id])
        CharacterizeJob.perform_now(file_set, file_set.original_file.id)
      end

      context 'request application/zip' do
        it 'returns a success response' do
          get :show, params: { id: dataset.id, format: :zip }
          expect(response).to be_successful
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

      before do
        allow(subject).to receive(:available_file_set_ids).and_return([])
      end

      context 'request application/zip but without filesets' do
        it 'returns a failed response' do
          get :show, params: { id: dataset.id, format: :zip }
          expect(response).not_to be_successful
        end
      end
    end

    context 'with restricted file_sets' do
      let(:file_set) { create(:file_set, :restricted) }
      let(:dataset) { create(:dataset, members: [file_set]) }

      context 'request application/zip' do
        it 'returns a failed response' do
          get :show, params: { id: dataset.id, format: :zip }
          expect(response).not_to be_successful
        end
      end
    end

    context 'with a long filename' do
      before do
        allow(subject).to receive(:authorize_download!).and_return(true)
        allow(subject).to receive(:available_file_set_ids).and_return([file_set.id])
        CharacterizeJob.perform_now(file_set, file_set.original_file.id)
      end

      let(:file_set) { create(:file_set, :long_filename) }
      let(:dataset) { create(:dataset, members: [file_set]) }

      context 'request application/zip' do
        it 'returns a success response' do
          get :show, params: { id: dataset.id, format: :zip }
          expect(response).to be_successful
        end
      end
    end
  end
end
