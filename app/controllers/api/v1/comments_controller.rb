class Api::V1::CommentsController < Api::V1::ApplicationController
  before_action :set_post
  before_action :set_comment, only: [ :edit, :destroy ]
  before_action :comment_params, only: [ :create, :edit ]

  def index
    @comments = Comment.where({ post_id: @post&.id })
    render json: { success: true, data: @comments }, status: :ok
  end

  def create
    @comment = @post.comments.new(comment_params.merge(user: @current_user))
    if @comment.save
      render json: { success: true, data: @comment }, status: :created
    else
      render json: { success: false, errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  def edit
    if @comment.user.id != @current_user.id
      return render json: { success: false, errors: "Unauthorized" }, status: :unauthorized
    end

    if @comment.update(comment_params)
      render json: { success: true, data: @comment }, status: :ok
    else
      render json: { success: false, errors: "Invalid Data " }, status: :bad_request
    end
  end

  def destroy
    if @comment.user.id != @current_user.id
      return render json: { success: false, errors: "Unauthorized" }, status: :unauthorized
    end
    @comment.destroy
    head :no_content
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  rescue
    render json: { success: false, errors: "Missing params" }, status: :bad_request
  end

  def set_post
    @post = Post.find(params[:post_id])
    if @post.nil?
      render json: { success: false, errors: "No Post with id #{params[:id]}" }
    end
  rescue
    render json: { success: false, errors: "No Post with id #{params[:id]}" }, status: :not_found
  end

  def set_comment
    @comment = Comment.find(params[:id])
    if @comment.nil?
      render json: { success: false, errors: "No Comment with id #{:id}" }, status: :not_found
    end
  rescue
    render json: { success: false, errors: "No Comment with id #{:id}" }, status: :not_found
  end
end
