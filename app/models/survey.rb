class Survey < ActiveRecord::Base

  has_many :survey_blocks, dependent: :destroy
  has_many :questions , through: :survey_blocks
  has_and_belongs_to_many :assignments


  accepts_nested_attributes_for :survey_blocks

  validates :name, presence: true
  validates :description, presence: true

  def valid_block_weights

    self.survey_blocks.each do |s|
      if s.weight == nil
        return false
      end
    end

    if self.survey_blocks.map(&:weight).inject(0, &:+) != 100
      return false
    else
      return true
    end
  end

  def valid_question_weights

    self.survey_blocks.each do |s|
      if s.questions
        s.questions.each do |q|
          if q.weight == nil
            return false
          end
        end
      else
        return false
      end
    end

    self.survey_blocks.each do |block|
      if block.questions.map(&:weight).inject(0, &:+) != block.weight
        return false
      end
    end
    return true

  end

  def self.options_for_select
    order('id').map { |e| [e.name, e.id] }
  end

end
