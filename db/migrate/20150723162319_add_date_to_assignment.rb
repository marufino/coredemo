class AddDateToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :date, :datetime
  end
end
