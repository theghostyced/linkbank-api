require 'rails_helper'

describe 'Boomark routes tests' do
  it "should route to the index page" do
    expect(get 'bookmarks').to route_to('bookmarks#index')
  end

  it "should route to the create page" do
    expect(post '/bookmarks').to route_to('bookmarks#create')
  end
end