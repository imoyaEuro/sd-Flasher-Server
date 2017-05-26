class AddAdminToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :admin, :boolean, :default => false
  end
end
