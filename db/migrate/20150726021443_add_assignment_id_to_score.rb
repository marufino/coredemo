class AddAssignmentIdToScore < ActiveRecord::Migration
  def change
    add_column :scores, :assignment_id, :integer
  end
end
