class LettersController < ApplicationController
  before_action :set_letter, only: %i[ show edit update destroy ]
  before_action :set_letterbox, only: %i[ index show new create ]

  # GET /letters or /letters.json
  def index
    @letters = @letterbox.letters.all
  end

  # GET /letters/1 or /letters/1.json
  def show
  end

  # GET /letters/new
  def new
    @letter = Letter.new
  end

  # GET /letters/1/edit
  def edit
  end

  # POST /letters or /letters.json
  def create
    @letter = @letterbox.letters.build(letter_params)
    @letter.user_id = current_user&.id
    if @letter.save
      redirect_to letterbox_letters_path(@letterbox), notice: "Letter was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /letters/1 or /letters/1.json
  def update
    respond_to do |format|
      if @letter.update(letter_params)
        format.html { redirect_to @letter, notice: "Letter was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }

      end
    end
  end

  # DELETE /letters/1 or /letters/1.json
  def destroy
    @letter.destroy!

    respond_to do |format|
      format.html { redirect_to letters_path, status: :see_other, notice: "Letter was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_letter
      @letter = Letter.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def letter_params
      params.expect(letter: [ :title, :body, :radio_name ])
    end

    def set_letterbox
      @letterbox = Letterbox.find(params[:letterbox_id])
    end
end
