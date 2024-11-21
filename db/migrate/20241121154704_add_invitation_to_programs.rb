class AddInvitationToPrograms < ActiveRecord::Migration[7.2]
  def change
    add_column :programs, :invitation_digest, :string
    add_column :programs, :send_invitation_at, :datetime
  end
end
