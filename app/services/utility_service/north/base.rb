module UtilityService
  module North
    class Base < UtilityService::Base
      private

      def request_mapper
        @request_mapper ||= UtilityService::North::RequestMapper.new(@utility)
      end

      def response_mapper
        @response_mapper ||= UtilityService::North::ResponseMapper.new(@utility)
      end

      def failed_response_mapper
        @failed_response_mapper ||= UtilityService::North::FailedResponseMapper.new(@utility)
      end
    end
  end
end
