# app/controllers/api/users_controller.rb
module Api
  class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:register, :login]

    # Register a new user
    def register
      # Validate the input
      validation_result = UserRegisterValidator.validate(params.permit(:username, :password, :email))
      unless validation_result[:success]
        render json: { errors: validation_result[:errors] }, status: :unprocessable_entity
        return
      end
    
      # Check if the username is already taken
      if UserService.username_taken?(params[:username])
        render json: { errors: "Username is already taken" }, status: :unprocessable_entity
        return
      end
    
      # Create the user (also encrypt the password)
      result = UserService.create_user(
        username: params[:username],
        password: params[:password] # Pass plain text here
      )
    
      if result[:success]
        render json: { message: "User created successfully" }, status: :created
      else
        render json: { errors: result[:errors] }, status: :unprocessable_entity
      end
    end

    # Login a user
    def login
      # Validate the input
      validation_result = UserLoginValidator.validate(params.permit(:username, :password))
      unless validation_result[:success]
        render json: { errors: validation_result[:errors] }, status: :unprocessable_entity
        return
      end

      # Find the user by username
      fund_user_result = UserService.find_user_by_username(params[:username])
      user = fund_user_result[:user]
      unless fund_user_result[:success]
        render json: { errors: "Invalid username or password" }, status: :unauthorized
        return
      end

      # Check if the password is correct
      unless UserService.check_password(params[:password], user.hashed_password)
        render json: { errors: "Invalid username or password" }, status: :unauthorized
        return
      end

      token = JsonWebToken.encode({ user_id: user.id })
      render json: { token: token }, status: :ok
    end
  end
end