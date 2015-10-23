class AddTypeToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :type, :string, :limit => 45
    add_column :dishes, :children_ids, :integer, array: true, default: []
    add_index :dishes, :children_ids, using: 'gin'
  end
  
end
