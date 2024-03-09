class CreateAccountDeletionRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :account_deletion_requests do |t|
      t.references :user, null: true
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
