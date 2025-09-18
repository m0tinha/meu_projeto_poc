Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "login",    to: "auth#login"
      post "register", to: "auth#register"
      get  "dashboard", to: "dashboard#index"
      get  "admin_panel", to: "dashboard#admin_panel"
    end
  end
end

