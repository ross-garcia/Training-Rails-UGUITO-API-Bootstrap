require 'rails_helper'

describe RetrieveBooksWorker do
  describe '#execute' do
    subject(:execute_worker) do
      VCR.use_cassette "retrieve_books/#{utility_name}/valid_params" do
        described_class.new.execute(user.id, params)
      end
    end

    let(:author) { 'Rodrigo Lugo Melgar' }
    let(:params) { { author: author } }
    let(:user) { create(:user, utility: utility) }

    let(:expected_books_keys) do
      %i[id title author genre image_url publisher year]
    end

    context 'with utility service' do
      let_it_be(:utilities) do
        %i[north_utility south_utility]
      end

      include_context 'with utility' do
        let_it_be(:utility) { create(utilities.sample) }
      end

      context 'when the request to the utility succeeds' do
        it 'succeeds' do
          expect(execute_worker.first).to eq 200
        end

        it 'returns books as array' do
          expect(execute_worker.second[:books]).to be_instance_of(Array)
        end

        it 'returns the expected book keys' do
          expect(execute_worker.second[:books].first.keys).to contain_exactly(*expected_books_keys)
        end
      end

      context 'when the request to the utility fails' do
        subject(:execute_worker) do
          described_class.new.execute(user.id, params)
        end

        let(:expected_status_code) { 500 }
        let(:expected_response_body) { { error: 'message' } }
        let(:utility_service_method) { :retrieve_books }

        before do
          allow(utility_service_class).to receive(:new).and_return(utility_service_instance)
          allow(utility_service_instance).to receive(utility_service_method)
            .and_return(instance_double(utility_service_response_class,
                                        code: expected_status_code, body: expected_response_body))
          allow(utility_service_instance).to receive(:utility).and_return(utility)
        end

        it 'returns status code obtained from the utility service' do
          expect(execute_worker.first).to eq(expected_status_code)
        end

        it 'returns the body obtained from the utility service' do
          expect(execute_worker.second).to eq(expected_response_body)
        end
      end
    end
  end
end
