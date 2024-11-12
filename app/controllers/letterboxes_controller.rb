class LetterboxesController < ApplicationController
  before_action :set_letterbox, only: %i[ show edit update destroy ]

  # GET /letterboxes or /letterboxes.json
  def index
    @letterboxes = Letterbox.all
  end

  # GET /letterboxes/1 or /letterboxes/1.json
  def show
  end

  # GET /letterboxes/new
  def new
    @letterbox = Letterbox.new
  end

  # GET /letterboxes/1/edit
  def edit
  end

  # POST /letterboxes or /letterboxes.json
  def create
    @letterbox = Letterbox.new(letterbox_params)

    respond_to do |format|
      if @letterbox.save
        format.html { redirect_to @letterbox, notice: "Letterbox was successfully created." }
        format.json { render :show, status: :created, location: @letterbox }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @letterbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /letterboxes/1 or /letterboxes/1.json
  def update
    respond_to do |format|
      if @letterbox.update(letterbox_params)
        format.html { redirect_to @letterbox, notice: "Letterbox was successfully updated." }
        format.json { render :show, status: :ok, location: @letterbox }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @letterbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /letterboxes/1 or /letterboxes/1.json
  def destroy
    @letterbox.destroy!

    respond_to do |format|
      format.html { redirect_to letterboxes_path, status: :see_other, notice: "Letterbox was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_letterbox
      @letterbox = Letterbox.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def letterbox_params
      params.expect(letterbox: [ :title ])
    end
end
