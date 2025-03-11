class LetterStatusPolicy < ApplicationPolicy
  def read?
    user.admin? || program_producer?
  end

  def unread?
    read?
  end
end
