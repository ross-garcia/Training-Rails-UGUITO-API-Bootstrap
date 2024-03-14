describe Api::V1::NotesController, type: :controller do
  describe 'GET #index' do
    let(:allowed_keys) { %w[id title note_type content_length] }

    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      let!(:user_notes) { create_list(:note, 5, user: user) }

      context 'when fetching all the notes for user' do
        before { get :index }

        it 'responds with the expected notes json' do
          expect(response_body.count).to eq(user_notes.count)
        end

        it 'responds matches with allowed keys' do
          expect(response_body.first.keys).to match_array(allowed_keys)
        end

        it 'responds with 200 status' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when fetching books with page and page size params' do
        let(:page)            { 1 }
        let(:page_size)       { 2 }
        let(:user_notes) { create_list(:note, page_size, user: user) }

        before { get :index, params: { page: page, page_size: page_size } }

        it 'responds with the expected number of notes' do
          expect(response_body.count).to eq(page_size)
        end

        it 'responds matches with allowed keys' do
          expect(response_body.first.keys).to match_array(allowed_keys)
        end

        it 'responds with 200 status' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when fetching notes using filters' do
        let(:note_type) { 'review' }
        let(:user_notes) { create_list(:note, 5, user: user, note_type: note_type) }

        before { get :index, params: { note_type: note_type } }

        it 'responds with expected notes' do
          response_body.each { |note| expect(note['note_type']).to eq(note_type) }
        end

        it 'responds with 200 status' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when there is not a user logged in' do
      context 'when fetching all the notes for user' do
        before { get :index }

        it_behaves_like 'unauthorized'
      end
    end
  end

  describe 'GET #show' do
    let(:allowed_keys) { %w[id title note_type word_count created_at content user content_length] }

    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      context 'when fetching a valid note' do
        let(:note) { create(:note, user: user) }

        before { get :show, params: { id: note.id } }

        it 'responds matches with allowed keys' do
          expect(response_body.keys).to match_array(allowed_keys)
        end

        it 'responds with a note belonging to the logged in user' do
          expect(response_body.fetch('user').fetch('id')).to eq(user.id)
        end

        it 'responds with 200 status' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when fetching a invalid note' do
        before { get :show, params: { id: Faker::Number.number } }

        it 'responds with 404 status' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when there is not a user logged in' do
      context 'when fetching an note' do
        before { get :show, params: { id: Faker::Number.number } }

        it_behaves_like 'unauthorized'
      end
    end
  end

  describe 'POST #create' do
    let(:body) { { note: { title: title, content: content, note_type: note_type } } }
    let(:title) { Faker::Book.title }
    let(:content) { Faker::Lorem.words(number: 50).join(' ') }
    let(:note_type) { :review }

    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      let(:user) { create(:user, utility: utility) }

      context 'when North Utility' do
        let(:utility) { create(:north_utility) }

        context 'when the body of the request is correct' do
          before { post :create, params: body }

          it 'responds with 201 status' do
            expect(response).to have_http_status(:created)
          end

          it 'creates a new note' do
            expect { post :create, params: body }.to change(Note, :count).by(1)
          end
        end

        context 'when note type invalid' do
          let(:note_type) { :invalid }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'not create a note' do
            expect { post :create, params: body }.not_to change(Note, :count)
          end
        end

        context 'when content invalid' do
          let(:content) { Faker::Lorem.words(number: 51).join(' ') }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'not create a note' do
            expect { post :create, params: body }.not_to change(Note, :count)
          end
        end

        context 'when missing parameters' do
          let(:body) { { note: { content: content, note_type: note_type } } }

          before { post :create, params: body }

          it { is_expected.to respond_with :bad_request }

          it 'not create a note' do
            expect { post :create, params: body }.not_to change(Note, :count)
          end
        end
      end

      context 'when South Utility' do
        let(:utility) { create(:south_utility) }

        context 'when the body of the request is correct' do
          before { post :create, params: body }

          it 'responds with 201 status' do
            expect(response).to have_http_status(:created)
          end

          it 'creates a new note' do
            expect { post :create, params: body }.to change(Note, :count).by(1)
          end
        end

        context 'when note type invalid' do
          let(:note_type) { :invalid }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'not create a note' do
            expect { post :create, params: body }.not_to change(Note, :count)
          end
        end

        context 'when content invalid' do
          let(:content) { Faker::Lorem.words(number: 61).join(' ') }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'not create a note' do
            expect { post :create, params: body }.not_to change(Note, :count)
          end
        end

        context 'when missing parameters' do
          let(:body) { { note: { content: content, note_type: note_type } } }

          before { post :create, params: body }

          it { is_expected.to respond_with :bad_request }

          it 'not create a note' do
            expect { post :create, params: body }.not_to change(Note, :count)
          end
        end
      end
    end

    context 'when there is not a user logged in' do
      context 'when creating a note' do
        before { post :create, params: body }

        it_behaves_like 'unauthorized'
      end
    end
  end
end
