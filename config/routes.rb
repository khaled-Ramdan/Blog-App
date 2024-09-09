require "sidekiq/web"
Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"


  namespace :api do
    namespace :v1 do
      # Posts
      resources :posts, only: [ :index, :create, :show, :edit, :update, :destroy ]
      #  Comments
      resources :post do
        resources :comments, only: [ :index, :create, :edit, :destroy ]
      end
      # User
      post "authentication/signup"
      post "authentication/login"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
