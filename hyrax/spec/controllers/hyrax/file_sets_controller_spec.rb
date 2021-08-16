require 'rails_helper'
require 'devise'
require 'securerandom'

RSpec.describe Hyrax::FileSetsController do
  include Devise::Test::ControllerHelpers

  routes { Rails.application.routes }
  let(:user) { create(:user, id: SecureRandom.hex(10)) }
  let(:actor) { controller.send(:actor) }

  context 'when signed in' do
    before do
      sign_in user
    end

    describe '#update' do
      let(:file_set) do
        create(:file_set, user: user, id: SecureRandom.hex(10))
      end

      context 'when updating the attached file version' do
        before do
          allow(Hyrax::Actors::FileActor).to receive(:new).and_return(actor)
        end

        it 'returns a Hyrax::UploadedFile' do
          expect(actor).to receive(:update_content).with(
            instance_of(Hyrax::UploadedFile)
          ).and_return(true)
          file = fixture_file_upload('/xml/other.txt', 'text/plain')
          post :update, params: {
            id: file_set,
            file_set: {
              files: [file],
              permissions_attributes: [{ type: 'person', name: user.username, access: 'edit' }]
            }
          }
        end

        it 'should not return JSON response' do
          # disable JSON template temporarily
          # https://github.com/antleaf/nims-mdr-development/issues/326
          expect {
            get :show, params: { id: file_set, format: :json }
          }.to raise_error(ActionController::UnknownFormat)
        end
      end
    end
  end
end
