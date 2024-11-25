Rails.application.routes.draw do
  root "static_page#top"

  get    "/login",   to: "user_sessions#new"
  post   "/login",   to: "user_sessions#create"
  delete "/logout",  to: "user_sessions#destroy"

  get    "/letter_sent", to: "letters#sent"
  get    "/letter_random", to: "letters#random"
  get    "/letter_reset", to: "letters#reset"

  resources :programs do
    resources :letterboxes, only: %i[ index new create edit update destroy ]
    resources :letters, shallow: true do
      post "/publish", to: "letter_status#publish"
      post "/non_publish", to: "letter_status#non_publish"
      post "/read", to: "letter_status#read"
      post "/unread", to: "letter_status#unread"
    end
    resources :invitations, only: %i[ show new create edit update ]
  end
  resources :users

  get "up" => "rails/health#show", as: :rails_health_check
end
