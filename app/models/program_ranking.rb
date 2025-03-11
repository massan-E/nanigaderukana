class ProgramRanking < ApplicationRecord
  belongs_to :program

  validates :program_id, presence: true
  validates :letters_count, presence: true
  validates :ranked_on, presence: true
end
