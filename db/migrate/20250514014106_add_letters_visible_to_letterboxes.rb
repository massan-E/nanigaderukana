class AddLettersVisibleToLetterboxes < ActiveRecord::Migration[7.2]
  def change
    add_column :letterboxes, :letters_visible, :boolean, default: false
  end
end
