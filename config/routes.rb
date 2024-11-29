Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users, controllers: {
    # sessions: "users/sessions",
    registrations: "users/registrations"
  }
  root "static_page#top"

  resources :programs do
    resources :letterboxes, only: %i[ index new create edit update destroy ]
    resources :letters, only: %i[ show index new create destroy ], shallow: true do
      post "/publish", to: "letter_status#publish"
      post "/non_publish", to: "letter_status#non_publish"
      post "/read", to: "letter_status#read"
      post "/unread", to: "letter_status#unread"
    end
    resources :invitations, only: %i[ show new create edit update ]
    resource :random_letters, only: %i[ show ] do
      collection do
        get "random"
        get "reset"
      end
    end
  end

  resources :users, only: %i[ index show ]

  get "up" => "rails/health#show", as: :rails_health_check
end
