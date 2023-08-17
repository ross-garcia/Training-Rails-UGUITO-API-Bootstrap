module UtilityService
  class ResponseMapper
    def initialize(utility = nil)
      @utility = utility
    end

    def none(_response_code, response_body)
      response_body
    end

    def default_response(_response_code, response_body)
      {
        message: fetch_response_message(response_body),
        title: fetch_response_title(response_body)
      }
    end

    def utility_access_token(_response_code, response_body)
      {
        external_api_access_token: response_body['token'],
        external_api_access_token_expiration: response_body['expiration']
      }
    end

    private

    def fetch_response_message(response_body)
      response_body.is_a?(Hash) ? format_response_message(response_body) : nil
    end

    def fetch_response_title(response_body)
      response_body.is_a?(Hash) ? format_response_title(response_body) : nil
    end

    def format_response_message(response)
      response = to_downcase(response)
      response['message'] || response['mensaje']
    end

    def format_response_title(response)
      response = to_downcase(response)
      response['title'] || response['titulo']
    end

    def to_downcase(response)
      response.transform_keys(&:downcase)
    end
  end
end
