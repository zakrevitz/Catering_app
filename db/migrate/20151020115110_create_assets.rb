class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :assetable, polymorphic: true, index: true
      t.text :filename
      t.string :type
      t.timestamps null: false
    end
  end
end
