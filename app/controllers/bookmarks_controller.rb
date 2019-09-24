class BookmarksController < ApplicationController
  def index
    bookmarks = Bookmark.recent.page(params[:page]).per(params[:per_page])
    render json: bookmarks
  end
end
