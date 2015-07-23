class CreateTrainees < ActiveRecord::Migration
  def change
    create_table :trainees do |t|

      t.timestamps
    end
  end
end
