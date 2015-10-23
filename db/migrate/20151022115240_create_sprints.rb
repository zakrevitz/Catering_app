class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.text :title, null: false, :limit => 125
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps null: false
    end
  end
end
