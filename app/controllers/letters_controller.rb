class LettersController < ApplicationController
  before_action :set_letter, only: %i[ show edit update destroy ]
  before_action :set_program, only: %i[ index show new create random reset ]
  before_action :logged_in_user, only: %i[ index show edit update destroy ]
  before_action :editable_user, only: %i[ edit update destroy ]
  before_action :authorized_user, only: %i[ show random reset ]
  # before_action :set_letterbox, only: %i[ index show new create ]

  def index
    @q = @program.letters.includes(:letterbox).ransack(params[:q])
    @letters = @q.result(distinct: true)
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
      flash[:success] =  "Letter was successfully created."
      redirect_to @program
    else
      render "programs/show", status: :unprocessable_entity
    end
  end

  def update
    if @letter.update(letter_params)
      flash[:success] = "Letter was successfully updated."
      redirect_to @letter
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letter.destroy!
    flash[:success] = "Letter was successfully destroyed."
    redirect_to letters_path, status: :see_other
  end

  def sent; end

  def random
    @letterbox_id = params[:letterbox_id].to_i
    @letters = @letterbox_id == 0 ? @program.letters : Letterbox.find(@letterbox_id).letters
    return render "letters/nothing" unless @letters
    @letter = letter_sampling(@letters)
    @letter.present? ? @letter.update!(is_read: true) : (render "letters/nothing")
  end

  def reset
    @letterbox_id = params[:letterbox_id].to_i
    @letters = @letterbox_id == 0 ? @program.letters : Letterbox.find(@letterbox_id).letters
    @letters.reset_is_read
    redirect_to letter_random_path(letterbox_id: @letterbox_id, program_id: @program.id)
  end

  private

    def set_letter
      @letter = Letter.find(params[:id])
    end

    def letter_params
      params.require(:letter).permit(:body, :radio_name, :letterbox_id)
    end

    # def set_letterbox
    #   letterbox_id = params[:letter]&.dig(:letterbox_id)
    #   @letterbox = Letterbox.find(letterbox_id) if letterbox_id
    # end

    def set_program
      program_id = params[:program_id]
      @program = Program.find(program_id) if program_id
    end

    def letter_sampling(letters)
      random_letter_id = letters.where(publish: true, is_read: false).pluck(:id).sample
      random_letter = random_letter_id ? Letter.find(random_letter_id) : nil
    end

    def editable_user
      unless current_user == @letter.user || current_user.admin?
        redirect_to(root_url, status: :see_other)
      end
    end

    def authorized_user
      unless producer?(current_user, @program) || current_user.admin? || current_user == @letter&.user
        redirect_to(root_url, status: :see_other)
      end
    end
end
