class AddPublishToLetterboxes < ActiveRecord::Migration[7.2]
  def change
    add_column :letterboxes, :publish, :boolean, default: true
  end
end
