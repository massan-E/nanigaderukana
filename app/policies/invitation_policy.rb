class InvitationPolicy < ApplicationPolicy
  def show?
    user.admin? || program_producer?
  end

  def create?
    show?
  end

  def update?
    true
  end
end