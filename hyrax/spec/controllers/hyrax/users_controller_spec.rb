RSpec.describe Hyrax::UsersController, type: :controller do
  let(:user) { create(:user) }
  routes { Hyrax::Engine.routes }

  describe 'user list access' do
    context 'with hide_users_list?=enabled' do
      before do
        allow(Flipflop).to receive(:hide_users_list?).and_return(true)
      end

      describe 'with admin user' do
        before do
          sign_in create(:user, :admin)
        end

        it 'renders the user list' do
          get :index
          expect(response.code).to eq '200'
          expect(response).to render_template(:index)
        end

        it 'does return .json results' do
          get :index, params: { format: :json }
          expect(response).to be_successful
        end
      end

      describe 'with registered user' do
        before do
          sign_in user
        end

        it 'does not render the user list' do
          get :index
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
          expect(response).to have_http_status(302)
        end

        it 'does not return .json results' do
          get :index, params: { format: :json }
          expect(response).not_to be_successful
        end
      end

      describe 'with unauthenticated user' do
        before do
          sign_out user
        end

        it 'does not render the user list' do
          get :index
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
          expect(response).to have_http_status(302)
          expect(response).to redirect_to('/users/sign_in?locale=en')
        end

        it 'does not return .json results' do
          get :index, params: { format: :json }
          expect(response).not_to be_successful
        end
      end
    end

    context 'with hide_users_list?=disabled' do
      before do
        sign_out user
        allow(Flipflop).to receive(:hide_users_list?).and_return(false)
      end

      describe 'with unauthenticated user' do
        it 'renders the user list' do
          get :index
          expect(response.code).to eq '302'
          expect(response).to redirect_to('/users/sign_in?locale=en')
        end
      end
    end
  end
end
