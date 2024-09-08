Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Posts
      get "posts/index"
      get "posts/show"
      get "posts/new"
      get "posts/create"
      get "posts/edit"
      get "posts/update"
      get "posts/destroy"
      #  Comments
      get "comments/index"
      get "comments/show"
      get "comments/new"
      get "comments/create"
      get "comments/edit"
      get "comments/update"
      get "comments/destroy"
      # User
      post "authentication/signup"
      post "authentication/login"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
