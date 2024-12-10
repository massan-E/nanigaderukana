class LetterStatusController < ApplicationController
  before_action :set_letter, only: %i[ read unread]
  before_action :authenticate_user!, only: %i[ read unread ]
  before_action :email_registered_user, only: %i[ read unread ]

  def read
    @letter.update(is_read: true)
  end

  def unread
    @letter.update(is_read: false)
  end

  private

    def set_letter
      @letter = Letter.find(params[:letter_id])
    end
end
