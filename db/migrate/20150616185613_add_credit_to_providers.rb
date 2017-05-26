class AddCreditToProviders < ActiveRecord::Migration
  def change
  	add_column :providers, :credit, :integer, :default => 0
  end
end
