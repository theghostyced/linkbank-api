require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "#Validations" do
    it 'should test that factory bot is valid' do
      expect(FactoryBot.build :bookmark).to  be_valid
    end 
  
    it 'should check existence of url' do
      bookmark = FactoryBot.build :bookmark, url: ''
  
      expect(bookmark).not_to be_valid
      expect(bookmark.errors.messages[:url]).to include("can't be blank")
    end
  end

  describe "recent method tests" do
    it "should list the most recent bookmarks first" do
      old_bookmark = FactoryBot.create :bookmark
      new_bookmark = FactoryBot.create :bookmark

      expect(described_class.recent).to  eq(
        [new_bookmark, old_bookmark]
      )

      old_bookmark.update_column :created_at, Time.now
      expect(described_class.recent).to  eq(
        [old_bookmark, new_bookmark]
      )
    end
  end
end
