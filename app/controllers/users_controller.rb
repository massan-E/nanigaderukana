class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :logged_in_user, only %i[ index edit update destroy ]
  # before_action :correct_user,   only %i[ edit update]
  # before_action :admin_user,     only %i[ destroy ]

  def index
    # ページネーション入れる予定
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to なにがでるかな！？"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        redirect_to @user, notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      # params.require(:user).permit(:name, :password, :password_confirmation)
      # ↓これがRails8.0以降の新しい書き方
      params.expect(user: [ :name, :password, :password_confirmation ])
    end
end
