Rails.application.routes.draw do
  get    "/login",   to: "user_sessions#new"
  post   "/login",   to: "user_sessions#create"
  delete "/logout",  to: "user_sessions#destroy"

  resources :letters
  resources :letterboxes
  resources :users

  # Render無料枠でrails cが使えないので一時的な記述。admninユーザーが本番で作成できたら削除すること！
  get "set_admin", to: "admin#set_admin"

  get "up" => "rails/health#show", as: :rails_health_check
end
