class AddReferenceLetters < ActiveRecord::Migration[7.2]
  def change
    add_reference :letters, :program, foreign_key: true
  end
end
