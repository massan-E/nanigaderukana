class LetterStatusController < ApplicationController
  before_action :set_letter, only: %i[ read unread]
  before_action :authenticate_user!, only: %i[ read unread ]
  before_action :email_registered_user, only: %i[ read unread ]

  def read
    authorize @letter.program, policy_class: LetterStatusPolicy
    @letter.update(is_read: true)
  end

  def unread
    authorize @letter.program, policy_class: LetterStatusPolicy
    @letter.update(is_read: false)
  end

  def add_star
    @letter = Letter.find(params[:letter_id])
    @letter.assign_attributes(star: params[:star])
    # @letter.update(star: params[:star])

    respond_to do |format|
      format.turbo_stream
    end
  end

  def commit_star
    @letter = Letter.find(params[:letter_id])
    @letter.update(star: params[:star])

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

    def set_letter
      @letter = Letter.find(params[:letter_id])
    end
end
