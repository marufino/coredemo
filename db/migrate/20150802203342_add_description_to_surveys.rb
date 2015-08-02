class AddDescriptionToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :description, :string
  end
end
