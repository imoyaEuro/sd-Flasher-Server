class CreateSalesTable < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.belongs_to :provider
      t.belongs_to :package
      t.belongs_to :sd_package
      t.integer :price
      t.inet    :ip
      t.timestamps null: false
    end
  end
end
