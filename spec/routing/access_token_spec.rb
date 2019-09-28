require 'rails_helper'

describe 'Access Token routes tests' do
  it "should route to the access_token create page" do
    expect(post '/login').to route_to('access_tokens#create')
  end

  it "should route to the access_token destroy page" do
    expect(delete '/logout').to route_to('access_tokens#destroy')
  end
  
end