class ChangeUserIdNullInLetters < ActiveRecord::Migration[8.0]
  def change
    change_column_null :letters, :user_id, true
  end
end
