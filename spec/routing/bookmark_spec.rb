require 'rails_helper'

describe 'Boomark routes tests' do
  it "should route to the index page" do
    expect(get 'bookmarks').to route_to('bookmarks#index')
  end
end