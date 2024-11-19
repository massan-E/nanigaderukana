class AddColumnUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :remember_digest, :string
    add_column :users, :admin, :boolean, default: false
  end
end
