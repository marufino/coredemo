class AddAreaOfStrengthIdToScores < ActiveRecord::Migration
  def change
    add_column :scores, :area_of_strength_id, :integer
  end
end
