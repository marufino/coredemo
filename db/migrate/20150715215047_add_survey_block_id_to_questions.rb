class AddSurveyBlockIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :survey_block_id, :integer
  end
end
