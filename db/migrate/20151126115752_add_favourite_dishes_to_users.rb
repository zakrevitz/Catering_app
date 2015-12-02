class AddFavouriteDishesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favourite_dishes_id, :integer, array: true, default: []
  end
end
