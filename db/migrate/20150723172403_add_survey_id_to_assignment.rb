class AddSurveyIdToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :survey_id, :integer
  end
end
