class StaticPageController < ApplicationController
  def top
    @programs = Program.order(created_at: :desc).limit(3)
    @letterboxes = Letterbox.order(created_at: :desc).limit(3)
  end
end
