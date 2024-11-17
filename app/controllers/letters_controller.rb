class LettersController < ApplicationController
  before_action :set_letter, only: %i[ show edit update destroy ]
  before_action :set_letterbox, only: %i[ index show new create ]

  def index
    @letters = @letterbox.letters.all
  end

  def show
  end

  def new
    @letter = Letter.new
  end

  def edit
  end

  def create
    @letter = @letterbox.letters.build(letter_params)
    @letter.user_id = current_user&.id
    if @letter.save
      redirect_to letterbox_letters_path(@letterbox), notice: "Letter was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @letter.update(letter_params)
        format.html { redirect_to @letter, notice: "Letter was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }

      end
    end
  end

  def destroy
    @letter.destroy!

    respond_to do |format|
      format.html { redirect_to letters_path, status: :see_other, notice: "Letter was successfully destroyed." }
    end
  end

  private
    def set_letter
      @letter = Letter.find(params.expect(:id))
    end

    def letter_params
      params.expect(letter: [ :title, :body, :radio_name ])
    end

    def set_letterbox
      @letterbox = Letterbox.find(params[:letterbox_id])
    end
end
