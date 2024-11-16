class UserParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :program

  validates :user_id, uniqueness: { scope: :board_id }
end
