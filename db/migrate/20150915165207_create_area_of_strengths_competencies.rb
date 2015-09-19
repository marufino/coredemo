class CreateAreaOfStrengthsCompetencies < ActiveRecord::Migration
  def change
    create_table :area_of_strengths_competencies , :id => false do |t|
      t.references :area_of_strength
      t.references :competency
    end
    add_index :area_of_strengths_competencies, [:area_of_strength_id, :competency_id], name: 'aos_c';
    add_index :area_of_strengths_competencies, :area_of_strength_id, name: 'aos';
  end
end
