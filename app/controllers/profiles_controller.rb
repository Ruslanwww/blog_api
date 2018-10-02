class ProfilesController < ApplicationController
  def search_users
    if params[:user]
      @users = User.search(params[:user]).order("created_at DESC")
      render json: @users
    else
      render status: :bad_request
    end
  end

end