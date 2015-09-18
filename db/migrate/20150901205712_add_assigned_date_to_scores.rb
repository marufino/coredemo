class AddAssignedDateToScores < ActiveRecord::Migration
  def change
    add_column :scores, :assigned_date, :datetime
  end
end
