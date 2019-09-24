require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  describe "#index tests" do
    # Query our GET endpoint 'GET /bookmarks'
    subject { get :index } 

    it 'should return a success response' do
      subject

      expect(response).to have_http_status(:ok)
    end

    it 'should return a proper JSON repsonse' do

      # Use our Factory bot to create a list of bookmarks
      FactoryBot.create_list :bookmark, 5
      subject

      # Checking if our bookmarks have a url
      Bookmark.recent.each_with_index do |bookmark, index|
        expect(json_response[index]['attributes']).to eq({
          "url" => bookmark.url
        })
      end
    end

    it "should return bookmarks in decending order" do
      old_bookmark = FactoryBot.create :bookmark
      new_bookmark = FactoryBot.create :bookmark
      subject

      expect(json_response.first['id']).to eq(new_bookmark.id.to_s)
      expect(json_response.last['id']).to eq(old_bookmark.id.to_s)
    end

    it "should paginate the responses" do
      FactoryBot.create_list :bookmark, 4
      
      get :index, params: { page: 2, per_page: 2 }

      expect(json_response.length).to eq(2)
      expect(json_response.first['id']).to eq(
        Bookmark.recent.third.id.to_s
      )
    end
  end
end
