module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!

      def index
        render json: notes_filtered, status: :ok, each_serializer: IndexNoteSerializer
      end

      def show
        render json: show_note, status: :ok, serializer: ShowNoteSerializer
      end

      private

      def notes
        current_user.notes
      end

      def filtering_params
        params.permit(%i[note_type])
      end

      def notes_filtered
        order = params[:order].in?(%w[asc desc ASC DESC]) ? params[:order] : 'desc'

        notes.where(filtering_params)
             .order(created_at: order)
             .page(params[:page])
             .per(params[:page_size])
      end

      def show_note
        notes.find(params.require(:id))
      end
    end
  end
end
