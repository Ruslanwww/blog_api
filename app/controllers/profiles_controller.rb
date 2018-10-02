class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :show_user_posts]

  def show
    render json: @user
  end

  def show_user_posts
    @posts = @user.posts.order('created_at DESC')

    render json: @posts
  end

  def search_users
    if params[:user]
      @users = User.search(params[:user]).order('created_at DESC')
      render json: @users
    else
      render status: :bad_request
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

end