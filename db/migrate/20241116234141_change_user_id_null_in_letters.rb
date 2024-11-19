class ChangeUserIdNullInLetters < ActiveRecord::Migration[7.2]
  def change
    change_column_null :letters, :user_id, true
  end
end
