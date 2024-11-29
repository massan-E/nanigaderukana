class LetterStatusController < ApplicationController
  before_action :set_letter, only: %i[ publish non_publish read unread]
  before_action :authenticate_user!, only: %i[ publish non_publish read unread ]

  def publish
    @letter.update(publish: true)
  end

  def non_publish
    @letter.update(publish: false)
  end

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
