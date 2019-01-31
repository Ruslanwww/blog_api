class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :update, :destroy, :like]
  before_action :owner, only: [:update, :destroy]

  def index
    @posts = Post.all.order('created_at DESC')

    render json: @posts.as_json(include: [likes: {only: :user_id},
                                          user: {only: [:nickname, :avatar]}])
  end

  def show
    render json: @post.as_json(include: [likes: {only: :user_id},
                                         user: {only: [:nickname, :avatar]}])
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  def like
    if current_user.likes.exists?(post_id: @post.id)
      @like = @post.likes.find_by_user_id(current_user.id)
      if @like.destroy
        @post.likes_count -= 1
        @post.save
        render json: {likes_count: @post.likes.count, like_status: false}, status: :ok
      end
    else
      @like = @post.likes.build
      @like.user_id = current_user.id
      if @like.save
        @post.likes_count += 1
        @post.save
        render json: {likes_count: @post.likes.count, like_status: true}, status: :ok
      end
    end
  end

  private

    def owner
      @post = current_user.posts.find_by(id: params[:id])
      render json: 'You do not have permission to modify this post', status: :unauthorized if @post.nil?
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :image)
    end
end
