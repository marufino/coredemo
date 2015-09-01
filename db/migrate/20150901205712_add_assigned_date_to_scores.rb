class AddAssignedDateToScores < ActiveRecord::Migration
  def change
    add_column :scores, :assigned_date, :date
  end
end
