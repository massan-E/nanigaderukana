class AddColumnLetters < ActiveRecord::Migration[8.0]
  def change
    add_column :letters, :body, :text, null: false
    add_column :letters, :is_read, :boolean, default: false
    add_column :letters, :publish, :boolean, default: true

    add_reference :letters, :letterbox, foreign_key: true
    add_reference :letters, :user, foreign_key: true
  end
end
