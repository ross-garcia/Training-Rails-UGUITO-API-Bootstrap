module Api
  module V1
    class NotesController < ApplicationController
      def index
        render json: notes_filtered, status: :ok, each_serializer: IndexNoteSerializer
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
    end
  end
end
