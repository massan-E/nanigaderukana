class LetterStatusPolicy < ApplicationPolicy
  def read?
    user.admin? || program_producer?
  end

  def unread?
    read?
  end

  def add_star?
    read?
  end

  def commit_star?
    read?
  end
end
