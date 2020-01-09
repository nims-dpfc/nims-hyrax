require 'rails_helper'
require 'devise'

RSpec.describe Hyrax::FileSetsController do
  include Devise::Test::ControllerHelpers

  routes { Rails.application.routes }
  let(:user) { create(:user) }
  let(:actor) { controller.send(:actor) }

  context 'when signed in' do
    before do
      sign_in user
    end

    describe '#update' do
      let(:file_set) do
        create(:file_set, user: user)
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
      end
    end
  end
end
