class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :show_user_posts, :subscribe, :unsubscribe]
  before_action :authenticate_user!, only: [:subscribe, :unsubscribe, :subscribes_list]

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
        @subscription = current_user.subscriptions.build
        @subscription.friend_id = @user.id
        if @subscription.save
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
        @subscription = current_user.subscriptions.find_by_friend_id(@user.id)
        if @subscription.destroy
          render status: :ok
        end
      else
        render status: :bad_request
      end
    end
  end

  def subscribes_list
    @friends = User.where(id: current_user.subscriptions.pluck(:friend_id))
    render json: @friends
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

end