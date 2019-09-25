require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  context "#validations tests" do
    it "should validate important fields" do
      access_token = FactoryBot.build :access_token, token: nil

      expect(access_token).not_to be_valid
      expect(access_token.errors.messages[:token]).to include("can't be blank")
    end
  end

  context "#Access Token tests" do
    it "should generate a new token during initalization" do
      expect(described_class.new.token).to be_present
    end

    it "should generate a unique token everytime" do
      user = FactoryBot.create :user
      expect{user.create_access_token}.to change{described_class.count}.by(1)
      expect(user.build_access_token).to be_valid
    end
  end
end
