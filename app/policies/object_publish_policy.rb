class ObjectPublishPolicy < ApplicationPolicy
  def switch_publish?
    user.admin? || program_producer?
  end
end
