class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include UserSessionsHelper
  include ProgramsHelper
end
