class ChangeNameNullUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :name, false

    add_index :users, :name, unique: true
  end
end
