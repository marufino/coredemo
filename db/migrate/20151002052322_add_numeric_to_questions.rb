class AddNumericToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :numeric, :boolean
  end
end
