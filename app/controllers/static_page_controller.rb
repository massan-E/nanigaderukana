class StaticPageController < ApplicationController
  def top
    @programs = Program.last(3)
    @letterboxes = Letterbox.last(3)
  end
end
