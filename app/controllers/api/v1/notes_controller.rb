module Api
  module V1
    class NotesController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

      def index
        render json: notes, status: :ok, each_serializer: IndexNoteSerializer
      end

      def show
        render json: note, status: :ok, serializer: ShowNoteSerializer
      end

      private

      def all_notes
        Note.all
      end

      def filtering_params
        params[:note_type] = note_type
        params.permit(%i[note_type])
      end

      def note_type
        valid_note_type? ? params[:note_type] : nil
      end

      def valid_note_type?
        Note.note_types.keys.include?(params[:note_type])
      end

      def notes
        all_notes.where(filtering_params)
                 .order(created_at: order)
                 .page(params[:page])
                 .per(params[:page_size])
      end

      def order
        params[:order].in?(%w[asc desc ASC DESC]) ? params[:order] : 'desc'
      end

      def render_record_not_found
        render json: { error: not_found_error }, status: :not_found
      end

      def not_found_error
        I18n.t 'errors.render_record_not_found'
      end

      def note
        Note.find(params.require(:id))
      end
    end
  end
end
