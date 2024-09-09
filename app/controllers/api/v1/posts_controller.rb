class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: [ :show ]

  def index
    @posts = Post.all
    render json: { success: true, posts: @posts }
  end

  def show
    render json: { success: true, posts: @post}
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.permit(:title, :body, :tags)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
