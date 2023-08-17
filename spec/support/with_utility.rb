RSpec.shared_context 'with utility' do
  let(:utility_service_class) { utility.utility_service_type::Base }
  let(:utility_service_instance) { instance_double(utility_service_class) }
  let(:utility_service_response_class) { "#{utility_service_class}::Response".safe_constantize }
  let(:utility_name) { utility.class.name.underscore }

  let(:parameter_validator_service_class) { utility.parameter_validator_service_type::Base }
  let(:parameter_validator_service_instance) { instance_double(parameter_validator_service_class) }

  before do
    request.headers['Utility-ID'] = utility.code if respond_to?(:request)
  end
end
