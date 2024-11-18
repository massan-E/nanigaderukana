class LettersController < ApplicationController
  before_action :set_letter, only: %i[ show edit update destroy ]
  before_action :set_letterbox, only: %i[ index show new create ]
  before_action :set_program, only: %i[ index show new create ]

  def index
    @letters = @letterbox&.letters.all
    # @q = Person.ransack(params[:q])
    # @people = @q.result(distinct: true)
  end

  def show
  end

  def new
    @letter = Letter.new
    @letter.radio_name = current_user.name if current_user
    @letter.letterbox_id = @letterbox&.id
  end

  def edit
  end

  def create
    @letter = @letterbox.letters.build(letter_params)
    @letter.user_id = current_user&.id
    if @letter.save
      redirect_to letter_sent_path, notice: "Letter was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @letter.update(letter_params)
      redirect_to @letter, notice: "Letter was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letter.destroy!
    redirect_to letters_path, status: :see_other, notice: "Letter was successfully destroyed."
  end

  def sent; end

  private
    def set_letter
      @letter = Letter.find(params.expect(:id))
    end

    def letter_params
      params.expect(letter: [ :title, :body, :radio_name ])
    end

    def set_letterbox
      letterbox_id = params[:letter][:letterbox_id].to_i
      @letterbox = Letterbox.find(letterbox_id) unless letterbox_id == 0
    end

    def set_program
      program_id = params[:program_id]
      @program = Program.find(program_id) if program_id
    end
end
