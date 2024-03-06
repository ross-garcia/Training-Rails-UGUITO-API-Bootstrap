describe Api::V1::NotesController, type: :controller do
  describe 'GET #index' do
    let(:user_notes) { create_list(:note, 5, user: user) }
    let(:allowed_keys) { %w[id title note_type content_length] }

    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      let!(:expected) do
        ActiveModel::Serializer::CollectionSerializer.new(
          notes_expected,
          serializer: IndexNoteSerializer
        ).to_json
      end

      context 'when fetching all the notes for user' do
        let(:notes_expected) { user_notes }

        before { get :index }

        it 'responds with the expected notes json' do
          expect(response_body.count).to eq(JSON.parse(expected).count)
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
        let(:notes_expected) { user_notes.first(2) }

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

        let!(:notes_custom) { create_list(:note, 2, user: user, note_type: note_type) }
        let(:notes_expected) { notes_custom }

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

      let(:expected) { ShowNoteSerializer.new(note, root: false).to_json }

      context 'when fetching a valid note' do
        let(:note) { create(:note, user: user) }

        before { get :show, params: { id: note.id } }

        it 'responds with the note json' do
          expect(response.body).to eq(expected)
        end

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
    let(:user) { create(:user, utility: utility) }
    let(:body) { { note: { title: title, content: content, note_type: note_type } } }
    let(:title) { Faker::Book.title }
    let(:content) { Faker::Lorem.words(number: 50).join(' ') }
    let(:note_type) { :review }

    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      context 'when North Utility' do
        let(:utility) { create(:north_utility) }

        context 'when the body of the request is correct' do
          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when note type invalid' do
          let(:note_type) { :invalid }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when content invalid' do
          let(:content) { Faker::Lorem.words(number: 51).join(' ') }
          let(:note_type) { :review }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when missing parameters' do
          let(:body) { { note: { content: content, note_type: note_type } } }

          before { post :create, params: body }

          it { is_expected.to respond_with :bad_request }
        end
      end

      context 'when South Utility' do
        let(:utility) { create(:south_utility) }
        let(:body) { { note: { title: title, content: content, note_type: note_type } } }

        context 'when the body of the request is correct' do
          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when note type invalid' do
          let(:note_type) { :invalid }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when content invalid' do
          let(:content) { Faker::Lorem.words(number: 61).join(' ') }
          let(:note_type) { :review }

          before { post :create, params: body }

          it 'responds with 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'when missing parameters' do
          let(:body) { { note: { content: content, note_type: note_type } } }

          before { post :create, params: body }

          it { is_expected.to respond_with :bad_request }
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
