class AddCompletedToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :completed, :boolean
  end
end
