class CreateLetterboxes < ActiveRecord::Migration[7.2]
  def change
    create_table :letterboxes do |t|
      t.string :title

      t.timestamps
    end
  end
end
