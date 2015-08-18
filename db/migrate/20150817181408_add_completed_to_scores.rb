class AddCompletedToScores < ActiveRecord::Migration
  def change
    add_column :scores, :completed, :boolean
  end
end
