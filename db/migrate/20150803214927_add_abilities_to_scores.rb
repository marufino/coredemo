class AddAbilitiesToScores < ActiveRecord::Migration
  def change
    add_column :scores, :abilities, :integer
  end
end
