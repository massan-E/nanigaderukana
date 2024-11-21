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
    resources :letters, shallow: true
    resources :invitations, only: %i[ show new create edit update ]
  end
  resources :users

  get "up" => "rails/health#show", as: :rails_health_check
end
