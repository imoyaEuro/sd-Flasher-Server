class CreateSdPackages < ActiveRecord::Migration
  def change
    create_table :sd_packages do |t|
      t.string :key
      t.string :tablet
      t.belongs_to :provider, index: true
      t.timestamps null: false
    end
  end
end
