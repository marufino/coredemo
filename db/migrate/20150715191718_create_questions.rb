class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :category
      t.integer :weight
      t.text :description

      t.timestamps
    end
  end
end
