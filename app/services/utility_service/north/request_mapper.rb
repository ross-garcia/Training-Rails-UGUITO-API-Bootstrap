module UtilityService
  module North
    class RequestMapper < UtilityService::RequestMapper
      def retrieve_books(params)
        get_params(params)
      end

      def retrieve_notes(params)
        get_params(params)
      end

      private

      def get_params(params)
        { autor: params['author'] }
      end
    end
  end
end
