class AddStateToSprint < ActiveRecord::Migration
  def change
    add_column :sprints, :aasm_state, :string
  end
end
