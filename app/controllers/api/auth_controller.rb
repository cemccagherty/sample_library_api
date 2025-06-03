class Api::AuthController < ApplicationController
  skip_before_action :authorize_request, only: [ :login, :signup ]

  def login
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized # returns HTTP 401
    end
  end

  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
