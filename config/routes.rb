Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :bookmarks, only: [:index]
  post "/login", to: "access_tokens#create"
end
