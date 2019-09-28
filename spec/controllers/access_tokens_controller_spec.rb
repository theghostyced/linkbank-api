require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe "AccessTokens POST #create" do
    # https://relishapp.com/rspec/rspec-core/v/2-0/docs/example-groups/shared-example-group
    # For more context on shared examples, use the link above
    shared_examples_for "unauthorized_requests" do
      let(:error) do
        {
          "status" => "401",
          "source" => { "pointer" => "/oauth_code" },
          "title" =>  "Authentication Code is invalid",
          "detail" => "Please provide a valid authentication code"
        }
      end

      it "should return 401 status code for invalid request" do
        subject
        expect(response).to have_http_status(401)
      end

      it "should have an error body" do
        subject
        expect(json['errors']).to include(error)
      end
    end

    context "when no oauth_code is provided" do
      subject { post :create }

      it_behaves_like "unauthorized_requests"
    end

    context "when invalid oauth_code is provided" do
      subject { post :create, params: { oauth_code: 'invalid code' } }

      it_behaves_like "unauthorized_requests"
    end

    context "when a valid request" do
      subject { post :create, params: { oauth_code: 'valid_code' } }

      let(:user_data) do { 
        login: 'jdoe1',
        url: 'http://example.com',
        avatar_url: 'http://example.com/avater.png',
        name: 'John Doe'
       }
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return('validaccesstoken')
        
        allow_any_instance_of(Octokit::Client).to receive(
          :user).and_return(user_data)
      end

      it "should return a 201 created status code" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "should return a valid json body" do
        subject
        user = User.find_by(login: 'jdoe1')

        expect(json_response['attributes']).to eq({
          'token' => user.access_token.token
        })
      end
    end

    describe "AccessTokens DELETE #create" do
      subject { delete :destroy }

      context "when no authorization code is passed to headers" do
        it_behaves_like "forbidden_requests"
      end

      context "when invalid auth code is passed to the headers" do
        before { request.headers['authorization'] = 'Invalid token' }
        it_behaves_like "forbidden_requests"
      end

      context "when valid auth token is passed" do
        let(:user) { FactoryBot.create :user }
        let(:access_token) { user.create_access_token }

        before {request.headers['authorization'] = "Bearer #{access_token.token}"}

       it "should return 204 status" do
        subject
        expect(response).to have_http_status(:no_content)
       end
       
       it "should destroy the access token" do
         expect {subject}.to change{AccessToken.count}.by(-1)
       end
      end
    end
  end
end
