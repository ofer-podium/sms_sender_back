Rails.application.routes.draw do
  namespace :api do
    # Users routes
    resources :users, only: %i[index show update destroy] do
      collection do
        post :register
        post :login
      end
    end

    # Messages routes
    resources :messages, only: %i[index show update destroy] do
      collection do
        post :send_message
        get :user_messages
        post :message_status
      end
    end
  end

  # Root route for the API
  root "api#index"
end

