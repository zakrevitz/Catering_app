class CreateDailyRations < ActiveRecord::Migration
  def change
    create_table :daily_rations do |t|
      t.belongs_to :sprint, index: true, using: 'gin'
      t.belongs_to :user, index: true, using: 'gin'
      t.belongs_to :daily_menu, index: true, using: 'gin'
      t.belongs_to :dish, index: true, using: 'gin'
      t.float      :price, null: false
      t.integer    :quantity, null: false, default: '1'
      t.timestamps null: false
    end
  end
end
