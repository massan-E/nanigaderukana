class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :logged_in_user, only %i[ index edit update destroy ]
  # before_action :correct_user,   only %i[ edit update]
  # before_action :admin_user,     only %i[ destroy ]

  def index
    # ページネーション入れる予定
    @users = User.all
  end

  def show
    @programs = @user.joined_programs.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to Music Hour"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        redirect_to @user, notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
