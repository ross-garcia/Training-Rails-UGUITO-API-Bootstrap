module TransformResponseService
  module South
    class Dispatcher
      include TransformResponseService::Dispatcher

      def perform(service_name, mapped_utility_response, *worker_params)
        @service_name = service_name
        @utility_response = mapped_utility_response
        @worker_params = worker_params

        try_call_external_poro_or_base(utility_external_poro, utility_base_class) || super
      end
    end
  end
end
