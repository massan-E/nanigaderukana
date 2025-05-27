class AddUrlToProgram < ActiveRecord::Migration[7.2]
  def change
    add_column :programs, :url, :string
  end
end
