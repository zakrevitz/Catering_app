class DropTableBusinesslunch < ActiveRecord::Migration
  def change
    drop_table :business_lunches
  end
end
