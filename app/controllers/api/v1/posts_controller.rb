class Api::V1::PostsController < Api::V1::ApplicationController
  before_action :set_post, only: [ :show, :update, :edit, :destroy  ]
  before_action :post_params, only: [ :create, :edit  ]



  def index
    @posts = Post.all
    render json: { success: true, data: @posts }, status: :ok
  end

  def show
    render json: { success: true, data: @post }, status: :ok
  end

  def create
    @post = @current_user.posts.new(post_params)

    if @post.save
      PostsDeletionJob.perform_at(24.hours.from_now, @post.id)
      render json: { success: true, data: @post }, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def edit
    if @post&.user&.id != @current_user.id
      return render json: { success: false, errors: "Unauthorized" }, status: :unauthorized
    end

    if @post.update(post_params&.slice(:title, :body))
      render json: { success: true, data: @post }
    else
      render json: { success: false, errors: "Invalid data" }
    end
  end
  def update
    # will be implemented when adding json column [updating tags only]
  end

  def destroy
    if @post.user != @current_user
      return render json: { success: false, errors: "Unautherized" }, status: :forbidden
    end
    @post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :tags)
  rescue
    render json: { success: false, errors: "Missing params" }, status: :bad_request
  end


  def set_post
    @post = Post.find(params[:id])
    if @post.nil?
      render json: { success: false, errors: "No Post with id #{params[:id]}" }
    end
  rescue
    render json: { success: false, errors: "No Post with id #{params[:id]}" }
  end
end
