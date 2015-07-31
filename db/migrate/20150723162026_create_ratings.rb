class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :observer, index: true
      t.belongs_to :score, index: true
      t.belongs_to :question, index: true
      t.integer :value

      t.timestamps
    end
  end
end
