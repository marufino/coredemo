class AddTotalToScores < ActiveRecord::Migration
  def change
    add_column :scores, :total, :integer
  end
end
