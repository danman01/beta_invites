class CreateBetaInvitesBetaRequests < ActiveRecord::Migration
  def change
    create_table :beta_invites_beta_requests do |t|
      t.integer :user_id
      t.boolean :invite_sent
      t.string :invitation_token
      t.integer :invited_by
      t.datetime :invite_sent_at
      t.string :email
      t.string :kind
      t.text :comments
      t.string :name
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.timestamps
    end
  end
end
