# db/seeds.rb

Question.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
Question.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
Question.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')


survey = Survey.create()

block1 = survey.survey_blocks.create(category: 'Knowledge', weight: 30)
block1.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
block1.questions.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
block1.questions.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')

block2 = survey.survey_blocks.create(category: 'Skills', weight: 40)
block2.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')


block3 = survey.survey_blocks.create(category: 'Abilities', weight: 30)
block3.questions.create!(category: 'Planning', weight: 15, description: 'How well does the trainee plan for work')
