class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: "Account successfully created", user: user.to_json }, status: :created
    else
      render json: { message: "Account creation failed", cause: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    campaign_names = params[:campaign_names].split(',')
    @users = User.where(
      campaign_names.map {
        |name| "JSON_CONTAINS(campaigns_list, '{\"campaign_name\": \"#{name}\"}', '$')"
      }.join(' OR ')
    )

    render json: @users
  end

  def user_params
    params.require(:user).permit(:name, :email, campaigns_list: [:campaign_name, :campaign_id])
  end
end
