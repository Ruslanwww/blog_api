class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :show_user_posts, :subscribe, :unsubscribe, :subscriptions_list, :subscribers_list]
  before_action :authenticate_user!, except: [:show, :show_user_posts, :search_users]

  def show
    @subscriptions = Subscription.where(friend_id: @user.id)
    @subscribers_count = Subscription.where(user_id: @user.id).count
    render json: {
        user: @user,
        subscriptions: @subscriptions,
        subscribers_count: @subscribers_count
    }
  end

  def show_user_posts
    @posts = @user.posts.order('created_at DESC')

    render json: @posts.as_json(include: [likes: {only: :user_id},
                                          user: {only: [:nickname, :avatar]}])
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
        @subscription = current_user.subscriptions.find_by(friend_id: @user.id)
        if @subscription.destroy
          render status: :ok
        end
      else
        render status: :bad_request
      end
    end
  end

  def subscriptions_list
    @subscriptions = User.where(id: @user.subscriptions.pluck(:friend_id))
    render json: @subscriptions
  end

  def subscribers_list
    @subscribers = User.where(id: Subscription.where(friend_id: @user.id).pluck(:user_id))
    render json: @subscribers
  end

  def friends_posts
    @posts = Post.where(user_id: current_user.subscriptions.pluck(:friend_id))
                 .order('created_at DESC')
    render json: @posts.as_json(include: [likes: {only: :user_id},
                                          user: {only: [:nickname, :avatar]}])
  end

  def subscription_recommendations
    @friends_subscribe = User.where(id:
      Subscription.where(user_id:
      User.where(id: current_user.subscriptions.pluck(:friend_id))
          .pluck(:id)).pluck(:friend_id))
                             .where.not(id: current_user.id)
    @user_subscribe = User.where(id: current_user.subscriptions.pluck(:friend_id))
    @friends_of_friends = @friends_subscribe - @user_subscribe
    render json: @friends_of_friends.sample(6)
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

end