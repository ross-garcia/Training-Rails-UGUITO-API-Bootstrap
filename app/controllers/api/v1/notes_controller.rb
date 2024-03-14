module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!

      def index
        return render_invalid_note_type unless valid_note_type_filter?
        render json: notes, status: :ok, each_serializer: IndexNoteSerializer
      end

      def show
        render json: note, status: :ok, serializer: ShowNoteSerializer
      end

      def create
        return render_invalid_note_type unless valid_note_type?
        create_note
        render_create_note_successfully
      rescue ActiveRecord::RecordInvalid => e
        render_record_invalid(e.message)
      end

      private

      def notes
        current_user.notes.where(filtering_params)
                    .order(created_at: order)
                    .page(params[:page])
                    .per(params[:page_size])
      end

      def filtering_params
        params.permit [:note_type]
      end

      def note_type_filter
        params[:note_type]
      end

      def order
        params[:order].in?(%w[asc desc ASC DESC]) ? params[:order] : 'desc'
      end

      def valid_note_type_filter?
        note_type_filter.nil? || Note.note_types.keys.include?(note_type_filter)
      end

      def render_invalid_note_type
        render json: { error: invalid_note_type_error }, status: :unprocessable_entity
      end

      def invalid_note_type_error
        I18n.t 'errors.render_invalid_note_type'
      end

      def render_create_note_successfully
        render json: { message: 'Nota creada con éxito.' }, status: :created
      end

      def note
        current_user.notes.find(params.require(:id))
      end

      def create_note
        Note.create!(note_create_params_required.merge(user_id: current_user.id))
      end

      def note_create_params_required
        params.require(:note).require(%i[title content note_type])
        params.require(:note).permit(%i[title content note_type]).to_h
      end

      def note_type
        note_create_params_required[:note_type]
      end

      def valid_note_type?
        Note.note_types.keys.include?(note_type)
      end

      def render_record_invalid(error_message)
        render json: { error: error_message }, status: :unprocessable_entity
      end

      def limit_review_content_length
        current_user.utility.content_length_short
      end
    end
  end
end
