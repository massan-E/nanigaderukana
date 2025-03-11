class CreateProgramRankings < ActiveRecord::Migration[7.2]
  def change
    create_table :program_rankings do |t|
      t.references :program, null: false, foreign_key: true
      t.integer :letters_count, null: false
      t.date :ranked_on, null: false

      t.timestamps
    end

    add_index :program_rankings, :letters_count
  end
end
