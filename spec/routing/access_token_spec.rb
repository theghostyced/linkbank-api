require 'rails_helper'

describe 'Access Token routes tests' do
  it "should route to the access_token index page" do
    expect(post '/login').to route_to('access_tokens#create')
  end
end