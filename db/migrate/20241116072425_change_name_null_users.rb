class ChangeNameNullUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :name, false

    add_index :users, :name, unique: true
  end
end
