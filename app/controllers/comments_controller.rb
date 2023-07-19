class CommentsController < ApplicationController
  before_action :set_like, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :redirect_si_user_no_coincide_con_creador_del_post, only: %i[ edit update destroy ]

  before_action only: [:new, :create] do
    authorize_request(["author", "admin", "normal_user", nil])
   end

   before_action only: [:edit, :update, :destroy] do
    authorize_request(["admin"])
   end
  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @post = Post.find_by(id: params[:comment][:post_id])

    if @post
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user

      respond_to do |format|
        if @comment.save
          format.html { redirect_to @post, notice: "COMENTARIO CREADO EXITOSAMENTE" }
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      # Manejar el caso en que el post no se encuentra
      redirect_to root_path, alert: "Post not found"
    end
  end


  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "COMENTARIO ACTUALIZADO EXITOSAMENTE" }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url, notice: "COMENTARIO ELIMINADO EXITOSAMENTE" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :post_id)
    end
    def authorize_request(kind = nil)
      unless current_user && kind.include?(current_user.role)
        notice = "No estás autorizado para realizar esta acción"
        redirect_to posts_path, notice: notice
      end
    end
end
