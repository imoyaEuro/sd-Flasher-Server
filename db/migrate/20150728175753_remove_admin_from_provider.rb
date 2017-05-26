class RemoveAdminFromProvider < ActiveRecord::Migration
  def change
    remove_column :providers, :admin, :boolean
    remove_column :providers, :encrypted_password, :string
    remove_column :providers, :reset_password_token, :string
    remove_column :providers, :reset_password_sent_at, :datetime
    remove_column :providers, :remember_created_at, :datetime
    remove_column :providers, :sign_in_count, :integer
    remove_column :providers, :current_sign_in_at, :datetime
    remove_column :providers, :last_sign_in_at, :datetime
    remove_column :providers, :current_sign_in_ip, :inet
    remove_column :providers, :last_sign_in_ip, :inet
  end
end
