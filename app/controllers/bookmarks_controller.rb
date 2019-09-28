class BookmarksController < ApplicationController
  skip_before_action :authorized!, only: [:index]

  def index
    bookmarks = Bookmark.recent.page(params[:page]).per(params[:per_page])
    render json: bookmarks
  end

  def create
    bookmark = Bookmark.new bookmark_params

    if bookmark.valid?
      bookmark.save

      render json: bookmark, status: :created
    else
      render json: bookmark, status: :unprocessable_entity,
             adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  private

  def bookmark_params
    params.require(:data).require(:attributes).permit(:url) || ActionController::Parameters.new
  end
  
end
