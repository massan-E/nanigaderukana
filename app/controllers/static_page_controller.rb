class StaticPageController < ApplicationController
  def top
    @programs = Program.includes(:user).order(created_at: :desc).limit(5)
    @letterboxes = Letterbox.includes(:program).order(created_at: :desc).limit(3)
    @rankings = ProgramRanking.all.includes(:program)
  end
end
