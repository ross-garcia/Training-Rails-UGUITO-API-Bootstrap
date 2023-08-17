module Api
  module V1
    class BooksController < ApplicationController
      before_action :authenticate_user!

      def index
        render json: books_filtered, status: :ok, each_serializer: IndexBookSerializer
      end

      def show
        render json: show_book, status: :ok, serializer: ShowBookSerializer
      end

      def index_async
        response = execute_async(RetrieveBooksWorker, current_user.id, index_async_params)
        async_custom_response(response)
      end

      private

      def books
        current_user.books
      end

      def books_filtered
        books.where(filtering_params).page(params[:page]).per(params[:page_size])
      end

      def filtering_params
        params.permit(%i[author title genre publisher year])
      end

      def show_book
        books.find(params.require(:id))
      end

      def index_async_params
        { author: params.require(:author) }
      end
    end
  end
end
