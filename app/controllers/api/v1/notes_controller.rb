module Api
  module V1
    class NotesController < ApplicationController
      def index
        render json: index_response, status: :ok
      end

      def show
        render json: show_note, status: :ok, serializer: ShowNoteSerializer
      end

      private

      def notes
        Note.all
      end

      def filtering_params
        params.permit(%i[note_type])
      end

      def notes_filtered
        order = params[:order].in?(%w[asc desc ASC DESC]) ? params[:order] : 'desc'

        Note.where(filtering_params)
            .order(created_at: order)
            .page(params[:page])
            .per(params[:page_size])
      end

      def notes_filtered_serialized
        ActiveModel::Serializer::CollectionSerializer.new(
          notes_filtered,
          each_serializer: NoteSerializer
        )
      end

      def meta_data
        {
          current_page: notes_filtered.current_page,
          per_page: notes_filtered.limit_value,
          total: notes_filtered.total_pages,
          last_page: notes_filtered.last_page?
        }
      end

      def index_response
        {
          meta: meta_data,
          data: notes_filtered_serialized
        }
      end

      def show_note
        Note.find(params.require(:id))
      end
    end
  end
end
