require 'rails_helper'
require 'devise'
require 'securerandom'

RSpec.describe DownloadAllController, type: :controller do
  include Devise::Test::ControllerHelpers
  routes { Rails.application.routes }

  describe 'GET #show' do
    let(:file_set) { create(:file_set, id: SecureRandom.hex(10)) }
    let(:dataset) { create(:dataset, members: [file_set]) }

    context 'with public file_set' do
      before do
        allow(subject).to receive(:authorize_download!).and_return(true)
        allow(subject).to receive(:file_set_ids).and_return([file_set.id])
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

    context 'with more than 10 file_sets' do
      before do
        @file_set_ids = []
        @file_sets = []
        @user = create(:user, id: SecureRandom.hex(10))
        4.times do |i|
          file_set = create(:file_set, :open, user: @user, id: SecureRandom.hex(10))
          @file_sets.append(file_set)
          @file_set_ids.append(file_set.id)
          CharacterizeJob.perform_now(file_set, file_set.original_file.id)
        end
        4.times do |i|
          file_set = create(:file_set, :authenticated, user: @user, id: SecureRandom.hex(10))
          @file_sets.append(file_set)
          @file_set_ids.append(file_set.id)
          CharacterizeJob.perform_now(file_set, file_set.original_file.id)
        end
        4.times do |i|
          file_set = create(:file_set, :restricted, user: @user, id: SecureRandom.hex(10))
          @file_sets.append(file_set)
          @file_set_ids.append(file_set.id)
          CharacterizeJob.perform_now(file_set, file_set.original_file.id)
        end
        allow(subject).to receive(:authorize_download!).and_return(true)
      end
      let(:dataset) { create(:dataset, members: @file_sets, id: SecureRandom.hex(10)) }
      let(:user) { create(:user, id: SecureRandom.hex(10)) }

      it 'returns the open file set ids when not logged in' do
        get :show, params: { id: dataset.id, format: :zip }
        expect(subject.send(:file_set_ids).sort).to eq @file_set_ids[0..3].sort
        expect(subject.send(:file_set_ids).size).to eq 4
      end

      it 'returns the open and authenticated file set ids when logged in as an user' do
        # File depositors can download their files while the work is depositted by another user
        sign_in user
        get :show, params: { id: dataset.id, format: :zip }
        expect(subject.send(:file_set_ids).sort).to eq @file_set_ids[0..7].sort
        expect(subject.send(:file_set_ids).size).to eq 8
      end

      it 'returns all the file set ids when logged in as a depositor' do
        sign_in @user
        get :show, params: { id: dataset.id, format: :zip }
        expect(subject.send(:file_set_ids).sort).to eq @file_set_ids.sort
        expect(subject.send(:file_set_ids).size).to eq 12
      end
    end

    context 'without file_sets' do
      let(:dataset) { create(:dataset) }

      before do
        allow(subject).to receive(:file_set_ids).and_return([])
      end

      context 'request application/zip but without filesets' do
        it 'returns a failed response' do
          get :show, params: { id: dataset.id, format: :zip }
          expect(response).not_to be_successful
        end
      end
    end

    context 'with restricted file_sets' do
      let(:file_set) { create(:file_set, :restricted, id: SecureRandom.hex(10)) }
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
        allow(subject).to receive(:file_set_ids).and_return([file_set.id])
        CharacterizeJob.perform_now(file_set, file_set.original_file.id)
      end

      let(:file_set) { create(:file_set, :long_filename, id: SecureRandom.hex(10)) }
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
