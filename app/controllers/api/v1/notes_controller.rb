module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!
      before_action :note_create_params_required, only: [:create]

      def index
        return render_invalid_note_type unless valid_note_type_filter?
        render json: notes, status: :ok, each_serializer: IndexNoteSerializer
      end

      def show
        render json: note, status: :ok, serializer: ShowNoteSerializer
      end

      def create
        return render_invalid_note_type unless valid_note_type?
        return render json: { message: 'Nota creada con éxito.' }, status: :created if create_note
      rescue ActiveRecord::RecordInvalid => e
        render_invalid_content if e.record.errors.to_hash[:content]
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
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

      def render_invalid_content
        render json: { error: invalid_content_error }, status: :unprocessable_entity
      end

      def limit_review_content_length
        current_user.utility.content_length_short
      end

      def invalid_content_error
        I18n.t 'errors.render_invalid_content', limit: limit_review_content_length
      end
    end
  end
end
