module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(_resource, _opts = {})
          render json: { access_token: current_token }, status: :ok
        end

        def current_token
          request.headers['warden-jwt_auth.token']
        end
      end
    end
  end
end
