class LetterboxesController < ApplicationController
  before_action :set_letterbox, only: %i[ show edit update destroy ]
  before_action :set_program, only: %i[ index new create ]

  def index
    @letterboxes = @program.letterboxes.all
  end

  def show
  end

  def new
    @letterbox = Letterbox.new
  end

  def edit
  end

  def create
    @letterbox = @program.letterboxes.build(letterbox_params)
    if @letterbox.save
      redirect_to program_path(@program), notice: "Letterbox was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @letterbox.update(letterbox_params)
      redirect_to @letterbox, notice: "Letterbox was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letterbox.destroy!
    redirect_to letterboxes_path, status: :see_other, notice: "Letterbox was successfully destroyed."
  end

  private

    def set_letterbox
      @letterbox = Letterbox.find(params.expect(:id))
    end

    def letterbox_params
      params.expect(letterbox: [ :title ])
    end

    def set_program
      @program = Program.find(params[:program_id])
    end
end
