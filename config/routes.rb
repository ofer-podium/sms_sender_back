Rails.application.routes.draw do
  namespace :api do
    # Users routes
    resources :users, only: %i[index show update destroy] do
      collection do
        post :register
        post :login
      end

      # Nested messages routes under a specific user
      resources :messages, only: %i[index create] do
        collection do
          get :user_messages # Custom route to get all messages for a specific user
        end
      end
    end

    # Messages routes
    resources :messages, only: %i[index show update destroy] do
      collection do
        post :send_message
      end
    end
  end

  # Root route for the API
  root "api#index"
end