class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: "Account successfully created", user: { user_id: @user.id, nickname: @user.name } }, status: :created
    else
      render json: { message: "Account creation failed", cause: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def filter
    campaign_names = params[:campaign_names].split(',')
    @users = User.where("JSON_CONTAINS(campaigns_list, ?)", campaign_names.to_json)
    render json: @users
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    user_not_found unless @user
  end

  def user_not_found
    render json: { message: "No User found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :email, campaigns_list: [:campaign_name, :campaign_id])
  end
end
