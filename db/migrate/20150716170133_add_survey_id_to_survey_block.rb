class AddSurveyIdToSurveyBlock < ActiveRecord::Migration
  def change
    add_column :survey_blocks, :survey_id, :integer
  end
end
