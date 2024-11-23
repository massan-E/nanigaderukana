class StaticPageController < ApplicationController
  def top
    @programs = Program.includes(:user).order(created_at: :desc).limit(3)
    @letterboxes = Letterbox.includes(:program).order(created_at: :desc).limit(3)
  end
end
