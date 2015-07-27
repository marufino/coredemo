class AddScoreIdToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :score_id, :integer
  end
end
