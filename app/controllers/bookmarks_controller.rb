class BookmarksController < ApplicationController
  skip_before_action :authorized!, only: [:index]

  def index
    bookmarks = Bookmark.recent.page(params[:page]).per(params[:per_page])
    render json: bookmarks
  end
end
