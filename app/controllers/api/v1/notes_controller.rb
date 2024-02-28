module Api
  module V1
    class NotesController < ApplicationController
      def index
        render json: resp, status: :ok, each_serializer: IndexNoteSerializer
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

      def show_note
        Note.find(params.require(:id))
      end

      def meta_data
        {
          current_page: notes_filtered.current_page,
          per_page: notes_filtered.limit_value,
          total: notes_filtered.total_pages,
          last_page: notes_filtered.next_page
        }
      end

      def resp
        {
          meta: meta_data,
          data: notes_filtered
        }
      end
    end
  end
end
