class AutoCompleteController < ApplicationController
  def search
    set_program if params[:program_id].present?
    @model = params[:model_name].constantize

    @objects = case @model.to_s
    when "Program"
      Program.search(params[:q])
    when "Letterbox"
      @program.letterboxes.search(params[:q])
    when "Letter"
      @program.letters.search(params[:q])
    end

    respond_to do |format|
      format.js
    end
  end
end
