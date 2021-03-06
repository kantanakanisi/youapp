class V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update update_avatar destroy following followers]

  def index
    if params[:uid]
      @current_user = User.find_by(uid: params[:uid])
      render json: @current_user
    else
      @users = User.all
      render json: @users
    end
  end

  def latest
    @users = User.includes(:posts).limit(50).order('created_at DESC')

    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    render json: @user if @user.update(user_params)
  end

  def update_avatar
    @user.avatar.attach(params[:avatar])
    render json: @user
  end

  def following
    @users = @user.followings
    render json: @users
  end

  def followers
    @users = @user.followers
    render json: @users
  end

  def destroy
    @user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:email, :uid, :name, :profile, :avatar)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
