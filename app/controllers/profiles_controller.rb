class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :show_user_posts, :subscribe, :unsubscribe]

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

  def subscribe
    if current_user.id == @user.id
      render status: :bad_request
    else
      if current_user.subscriptions.exists?(friend_id: @user.id)
        render status: :bad_request
      else
        @subscribe = current_user.subscriptions.build
        @subscribe.friend_id = @user.id
        if @subscribe.save
          render status: :ok
        end
      end
    end
  end

  def unsubscribe
    if current_user.id == @user.id
      render status: :bad_request
    else
      if current_user.subscriptions.exists?(friend_id: @user.id)
        @subscribe = current_user.subscriptions.find_by_friend_id(@user.id)
        if @subscribe.destroy
          render status: :ok
        end
      else
        render status: :bad_request
      end
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

end