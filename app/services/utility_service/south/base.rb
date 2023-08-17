module UtilityService
  module South
    class Base < UtilityService::Base
      private

      def request_mapper
        @request_mapper ||= UtilityService::South::RequestMapper.new(@utility)
      end

      def response_mapper
        @response_mapper ||= UtilityService::South::ResponseMapper.new(@utility)
      end

      def failed_response_mapper
        @failed_response_mapper ||= UtilityService::South::FailedResponseMapper.new(@utility)
      end
    end
  end
end
