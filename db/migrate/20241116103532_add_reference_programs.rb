class AddReferencePrograms < ActiveRecord::Migration[8.0]
  def change
    add_reference :programs, :user, foreign_key: true
  end
end
