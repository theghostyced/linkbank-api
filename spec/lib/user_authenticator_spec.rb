require 'rails_helper'

describe UserAuthenticator do
  describe "#perform_authentication" do
    let(:error) {
      double("Sawyer::Resource", error: "bad_verification_code")
    }
    let(:authenticator) { described_class.new('sample code') }
    subject { authenticator.perform_authentication }

    context "when the oauth_code is incorrect" do
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(error)
      end
      

      it "should raise error" do
        expect{subject}.to raise_error(
          UserAuthenticator::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context "when the oauth_code is valid" do
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

      it "should user when they dont exist in DB" do
        expect{subject}.to change{User.count}.by(1)
        expect(User.last.name).to eq('John Doe')
      end

      it "should reuse existing user" do
        user = FactoryBot.create :user, user_data

        expect{subject}.not_to change{ User.count }
        expect(authenticator.user).to eq(user)
      end

      it "should create and set user's access token" do
        expect{subject}.to change{AccessToken.count}.by(1)
        expect(authenticator.access_token).to be_present
      end
    end
  end
end
