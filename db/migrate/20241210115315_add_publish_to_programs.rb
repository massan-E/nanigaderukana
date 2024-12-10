class AddPublishToPrograms < ActiveRecord::Migration[7.2]
  def change
    add_column :programs, :publish, :boolean, default: true
  end
end
