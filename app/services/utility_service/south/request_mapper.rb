module UtilityService
  module South
    class RequestMapper < UtilityService::RequestMapper
      def retrieve_books(params)
        get_params(params)
      end

      def retrieve_notes(params)
        get_params(params)
      end

      def get_params(params)
        { Autor: params['author'] }
      end
    end
  end
end
