class ObjectPublishController < ApplicationController
  before_action :set_program, only: %i[ switch_publish ]
  before_action :authorized_user, only: %i[ switch_publish ]
  before_action :set_object, only: %i[ switch_publish ]
  before_action :authenticate_user!, only: %i[ switch_publish ]
  before_action :email_registered_user, only: %i[ switch_publish ]

  def switch_publish
    @object.update(publish: !@object.publish)
  end

  private

    def set_object
      @model = params[:model_name].constantize
      @object = @model.find(params[:id])
    end

    def authorized_user
      unless producer?(current_user, @program) || current_user.admin?
        redirect_to(root_url, status: :see_other)
      end
    end
end
