class CreateUserParticipations < ActiveRecord::Migration[7.2]
  def change
    create_table :user_participations do |t|
      t.references :user, foreign_key: true
      t.references :program, foreign_key: true

      t.timestamps
    end
    add_index :user_participations, [ :user_id, :program_id ], unique: true
  end
end
