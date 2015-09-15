class AddAreaOfWeaknessIdToScores < ActiveRecord::Migration
  def change
    add_column :scores, :area_of_weakness_id, :integer
  end
end
