class LettersController < ApplicationController
  before_action :set_letter, only: %i[ show edit update destroy ]
  before_action :set_program, only: %i[ index show new create ]
  before_action :logged_in_user, only: %i[ index show edit update destroy ]
  before_action :editable_user, only: %i[ edit update destroy ]
  before_action :authorized_user, only: %i[ show ]

  def index
    @q = @program.letters.includes(:letterbox).ransack(params[:q])
    @result = @q.result(distinct: true)
    @letters = @result.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  def new
    @letter = Letter.new
    @letter.radio_name = current_user&.name
    @letter.letterbox_id = params[:letter]&.dig(:letterbox_id)
  end

  def edit
  end

  def create
    @letter = Letter.new(letter_params)
    @letter.user_id = current_user&.id
    @letter.program_id = params[:program_id]
    if @letter.save
      flash[:success] =  "お便りを送信しました"
      redirect_to @program
    else
      flash.now[:danger] = "お便りの送信に失敗しました、お便り入力フォームを確認してください"
      render "programs/show", status: :unprocessable_entity
    end
  end

  def update # このアクションいらん
    if @letter.update(letter_params)
      flash[:success] = "Letter was successfully updated."
      redirect_to @letter
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letter.destroy!
    flash[:success] = "お便りを削除しました"
    redirect_to letters_path, status: :see_other
  end

  private

    def set_letter
      @letter = Letter.find(params[:id])
    end

    def letter_params
      params.require(:letter).permit(:body, :radio_name, :letterbox_id)
    end

    def set_program
      program_id = params[:program_id]
      @program = Program.find(program_id) if program_id
    end


    def editable_user
      unless current_user == @letter.user || current_user.admin?
        redirect_to(root_url, status: :see_other)
      end
    end

    def authorized_user
      unless producer?(current_user, @program) || current_user&.admin? || current_user == @letter&.user
        redirect_to(root_url, status: :see_other)
      end
    end
end
