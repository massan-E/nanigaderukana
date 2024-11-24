class PublishController < ApplicationController
  before_action :set_letter, only: %i[ publish non_publish ]

  def publish
    @letter.update(publish: true)
  end

  def non_publish
    @letter.update(publish: false)
  end

  private

    def set_letter
      @letter = Letter.find(params[:letter_id])
    end
end
