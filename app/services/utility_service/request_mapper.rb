module UtilityService
  class RequestMapper
    def initialize(utility = nil)
      @utility = utility
    end

    def utility_access_token(key, secret)
      {
        app_id: key,
        app_secret: secret
      }
    end
  end
end
