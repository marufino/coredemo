class CreateSurveyBlocks < ActiveRecord::Migration
  def change
    create_table :survey_blocks do |t|
      t.string :category
      t.integer :weight

      t.timestamps
    end
  end
end
