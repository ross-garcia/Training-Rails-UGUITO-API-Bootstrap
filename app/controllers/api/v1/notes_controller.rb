module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!

      def index
        return render_invalid_filter_note_type unless valid_note_type?
        render json: notes, status: :ok, each_serializer: IndexNoteSerializer
      end

      def show
        render json: note, status: :ok, serializer: ShowNoteSerializer
      end

      private

      def current_user_notes
        current_user.notes
      end

      def filtering_params
        params.permit [:note_type]
      end

      def note_type
        params[:note_type]
      end

      def valid_note_type?
        note_type.nil? || Note.note_types.keys.include?(note_type)
      end

      def notes
        current_user_notes.where(filtering_params)
                          .order(created_at: order)
                          .page(params[:page])
                          .per(params[:page_size])
      end

      def order
        params[:order].in?(%w[asc desc ASC DESC]) ? params[:order] : 'desc'
      end

      def render_invalid_filter_note_type
        render json: { error: invalid_filter_note_type_error }, status: :bad_request
      end

      def invalid_filter_note_type_error
        I18n.t 'errors.render_invalid_filter_note_type'
      end

      def note
        current_user_notes.find(params.require(:id))
      end
    end
  end
end
