class AddLogoToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :logo, :string
  end
end
