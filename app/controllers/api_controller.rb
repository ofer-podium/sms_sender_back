class ApiController < ApplicationController
    def index
      render json: { message: "Server is alive" }
    end
  end