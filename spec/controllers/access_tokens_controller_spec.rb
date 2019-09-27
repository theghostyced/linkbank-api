require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe "AccessTokens #create" do
    let(:error) do
      {
        "status" => "401",
        "source" => { "pointer" => "/oauth_code" },
        "title" =>  "Authentication Code is invalid",
        "detail" => "Please provide a valid authentication code"
      }
    end

    context "when an invalid request" do
      it "should return 401 status code for invalid request" do
        post :create
        expect(response).to have_http_status(401)
      end

      it "should have an error body" do
        post :create
        expect(json['errors']).to include(error)
      end
      
    end

    context "when a valid request" do
      
    end
  end
end
