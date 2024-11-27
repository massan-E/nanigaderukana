class RandomLettersController < ApplicationController
  include LettersHelper
  before_action :set_program, only: %i[ show random reset ]
  before_action :authorized_user, only: %i[ show random reset ]

  def show
    @letters = fetch_letters(params[:q])
  end

  def random
    @letters = fetch_letters(params[:q])
    return render "letters/nothing" unless @letters
    @letter = letter_sampling(@letters)
    @letter.present? ? @letter.update(is_read: true) : (render "random_letters/nothing")
  end

  def reset
    @letters = fetch_letters(params[:q])
    @letters.reset_is_read
    redirect_to program_random_letters_path(q: permitted_q_params)
  end


  private

    def set_program
      program_id = params[:program_id]
      @program = Program.find(program_id) if program_id
    end

    def authorized_user
      unless producer?(current_user, @program) || current_user&.admin? || current_user == @letter&.user
        redirect_to(root_url, status: :see_other)
      end
    end

    def letter_sampling(letters)
      random_letter_id = letters.where(publish: true, is_read: false).pluck(:id).sample
      random_letter = random_letter_id ? Letter.find(random_letter_id) : nil
    end

    def fetch_letters(query_params)
      @q = @program.letters.includes(:letterbox).ransack(query_params)
      @q.result(distinct: true)
    end
end
