require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Valdiations tests" do
    it "should build a factory" do
      user = FactoryBot.build :user
      expect(user).to be_valid
    end

    it "should validate presence of required attributes" do
      user = FactoryBot.build :user, login: nil, provider: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:login]).to include("can't be blank")
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end
  end
end
