class CreateUserPrograms < ActiveRecord::Migration[8.0]
  def change
    create_table :user_programs do |t|
      t.references :user, foreign_key: true
      t.references :program, foreign_key: true

      t.timestamps
    end
    add_index :user_programs, [:user_id, :program_id], unique: true
  end
end
