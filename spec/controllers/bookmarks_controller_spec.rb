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

  describe "#create tests" do
    subject { post :create }

    context "when user doesnt provide access_token" do
      it_behaves_like "forbidden_requests"
    end

    context "when user is unauthorized" do
      before { request.headers['authorization'] = 'Invalid token' }

      it_behaves_like "forbidden_requests"  
    end

    context "when user is authorized" do
      let(:user) { FactoryBot.create :user }
      let(:access_token) { user.create_access_token }

      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context "when invalid params are passed" do
        let(:invalid_params) do
          {
            data: {
              attributes: {
                url: '',
              }
            }
          }
        end

        let(:bookmark_create_error) do
          {
            "source" => { "pointer" => "/data/attributes/url" },
            "detail" => "can't be blank"
          }
        end

        subject { post :create, params: invalid_params }

        it "should return 422 status code" do
          subject
  
          expect(response).to have_http_status(:unprocessable_entity)
        end
        
        it "should return the proper json error" do
          subject
  
          expect(json['errors']).to include(bookmark_create_error)
        end
      end

      context "when valid params are passed back" do
        let(:valid_params) do
          {
            'data' => {
              'attributes' => {
                'url' => 'https://google.com'
              }
            }
          }
        end

        subject { post :create, params: valid_params }

        it "should respond with 201 status code" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "should return proper json body" do
          subject
          expect(json_response['attributes']).to include(valid_params['data']['attributes'])
        end

        it "should create the bookmark" do
          expect{subject}.to change{Bookmark.count}.by(1)
        end
      end
    end
  end
end
