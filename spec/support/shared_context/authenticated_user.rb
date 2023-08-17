require 'devise/jwt/test_helpers'

RSpec.shared_context 'with authenticated user' do
  let(:user) { create(:user) }
  let!(:auth_headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }

  before { request.headers['Authorization'] = auth_headers['Authorization'] }
end
