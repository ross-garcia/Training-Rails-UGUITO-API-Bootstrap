module TransformResponseService
  module Dispatcher
    attr_reader :utility_type

    def initialize(utility, client)
      @utility = utility
      @client = client
      @utility_type = utility.type.chomp('Utility')
    end

    def perform(service_name, mapped_utility_response, *worker_params)
      @service_name = service_name
      @utility_response = mapped_utility_response
      @worker_params = worker_params

      try_call_external_poro_or_base(base_external_poro, base_class) ||
        utility_response.body
    end

    private

    attr_reader :utility, :client, :service_name, :utility_response, :worker_params

    def try_call_external_poro_or_base(poro, base_class)
      return call_external_poro(poro) if poro.present?

      call_base_class(base_class) if base_class.method_defined?(service_name)
    end

    def call_base_class(base_class)
      base_class.new(utility, client).send(service_name, utility_response, *worker_params)
    end

    def call_external_poro(external_poro)
      external_poro.new(utility, client).perform(utility_response, *worker_params)
    end

    def base_external_poro
      try_to_get_class(camelized_service_name)
    end

    def utility_external_poro
      try_to_get_class("#{utility_type}::#{camelized_service_name}")
    end

    def base_class
      TransformResponseService::Base
    end

    def utility_base_class
      "TransformResponseService::#{utility_type}::Base".safe_constantize
    end

    def try_to_get_class(class_name)
      # Set the inherit flag to 'false' for just looking up classes under
      # the TransformResponseService namespace
      TransformResponseService.const_get(class_name, false)
    rescue NameError, LoadError
      nil
    end

    def camelized_service_name
      service_name.to_s.camelize
    end
  end
end
