class AddRadioNameToLetters < ActiveRecord::Migration[8.0]
  def change
    add_column :letters, :radio_name, :string, default: "loving rabbit",  null: false
  end
end
