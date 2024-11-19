class AddReferencePrograms < ActiveRecord::Migration[7.2]
  def change
    add_reference :programs, :user, foreign_key: true
  end
end
