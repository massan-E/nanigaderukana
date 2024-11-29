class RemoveColumunFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :password_digest
    remove_column :users, :remember_digest
  end
end
