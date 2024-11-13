class AddColumnUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :remember_digest, :string
    add_column :users, :admin, :boolean, default: false
  end
end
