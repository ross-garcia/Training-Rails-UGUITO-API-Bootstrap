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
end
