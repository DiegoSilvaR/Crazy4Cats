class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :redirect_si_user_no_coincide_con_creador_del_post, only: %i[ edit update destroy ]

  before_action only: [:new, :create] do
    authorize_request(["author", "admin", "normal_user"])
   end

   before_action only: [:edit, :update, :destroy] do
    authorize_request(["admin"])
   end

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
    @comment = Like.new
    @likes = @post.likes
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user #o @post.user_id = current_user.id
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "POST CREADO EXITOSAMENTE" }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "POST ACTUALIZADO EXITOSAMENTE" }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "POST ELIMINADO EXITOSAMENTE" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit( :title, :content, :user_id, :image,)
    end
   def redirect_si_user_no_coincide_con_creador_del_post
  unless current_user && current_user.role == "admin"
    redirect_to posts_path, notice: "No puedes editar esta Noticia"
  end
end
end
