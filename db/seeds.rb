# db/seeds.rb

Question.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
Question.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
Question.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')

block = SurveyBlock.create!(category: 'Knowledge', weight: 30)
block.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')

SurveyBlock.create!(category: 'Skills', weight: 40)
SurveyBlock.create!(category: 'Abilities', weight: 30)
