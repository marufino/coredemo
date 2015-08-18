class AddCompletedDateToScores < ActiveRecord::Migration
  def change
    add_column :scores, :completed_date, :date
  end
end
