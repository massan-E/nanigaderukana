class StaticPageController < ApplicationController
  def top
    @program = Program.last(6)
  end
end
