class AddCulmunLetterboxes < ActiveRecord::Migration[8.0]
  def change
    change_column_null :letterboxes, :title, false
    add_column :letterboxes, :body, :text

    add_reference :letterboxes, :program, foreign_key: true
  end
end
