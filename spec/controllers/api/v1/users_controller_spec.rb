require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe 'GET #show_current_user' do
    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      let(:expected) { UserSerializer.new(user, root: false).to_json }

      before { get :current }

      it 'responds with the expected user json' do
        expect(response.body).to eq(expected)
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when there is not a user logged in' do
      context 'when fetching an account' do
        before { get :current }

        it_behaves_like 'unauthorized'
      end
    end
  end
end
