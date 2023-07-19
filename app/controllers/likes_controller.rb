class LikesController < ApplicationController
  before_action :set_like, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :redirect_si_user_no_coincide_con_creador_del_post, only: %i[ edit update destroy ]

  before_action only: [:new, :create] do
    authorize_request(["author", "admin", "normal_user"])
   end

   before_action only: [:edit, :update, :destroy] do
    authorize_request(["admin"])
   end
  # GET /likes or /likes.json
  def index
    @likes = Like.all
  end

  # GET /likes/1 or /likes/1.json
  def show
  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes or /likes.json
  def create
    @post = Post.find(params[:like][:post_id])
    @like = @post.likes.build(like_params)
    @like.user = current_user

    respond_to do |format|
      if @like.save
        format.html { redirect_to like_url(@like), notice: "TU LIKE FUE ENVIADO" }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /likes/1 or /likes/1.json
  def update
    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to like_url(@like), notice: "TU LIKE SE ACTUALIZO" }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1 or /likes/1.json
  def destroy
    @like.destroy

    respond_to do |format|
      format.html { redirect_to likes_url, notice: "TU LIKE FUE ELIMINADO" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_like
    @like = Like.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def like_params
    params.require(:like).permit(:post_id)
  end
  def authorize_request(kind = nil)
    unless current_user && kind.include?(current_user.role)
      notice = "No estás autorizado para realizar esta acción"
      redirect_to posts_path, notice: notice
    end
  end
end
