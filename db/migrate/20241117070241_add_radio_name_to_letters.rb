class AddRadioNameToLetters < ActiveRecord::Migration[7.2]
  def change
    add_column :letters, :radio_name, :string, default: "loving rabbit",  null: false
  end
end
