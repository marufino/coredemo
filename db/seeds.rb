# db/seeds.rb

Question.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
Question.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
Question.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')


survey = Survey.create(name: 'Sales Base')

block1 = survey.survey_blocks.create(category: 'Knowledge', weight: 30)
block1.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
block1.questions.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
block1.questions.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')

block2 = survey.survey_blocks.create(category: 'Skills', weight: 40)
block2.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')


block3 = survey.survey_blocks.create(category: 'Abilities', weight: 30)
block3.questions.create!(category: 'Planning', weight: 15, description: 'How well does the trainee plan for work')

survey = Survey.create(name: 'Sales Advanced')

block1 = survey.survey_blocks.create(category: 'Knowledge', weight: 30)
block1.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
block1.questions.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
block1.questions.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')

block2 = survey.survey_blocks.create(category: 'Skills', weight: 40)
block2.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')


block3 = survey.survey_blocks.create(category: 'Abilities', weight: 30)
block3.questions.create!(category: 'Planning', weight: 15, description: 'How well does the trainee plan for work')


User.create(email: 'observer1@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '1', meta_type: 'Observer')
Observer.create(id: '1')
User.create(email: 'observer2@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '2', meta_type: 'Observer')
Observer.create(id: '2')
User.create(email: 'observer3@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '3', meta_type: 'Observer')
Observer.create(id: '3')

User.create(email: 'user1@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '1', meta_type: 'Trainee')
Trainee.create(id: '1')
User.create(email: 'user2@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '2', meta_type: 'Trainee')
Trainee.create(id: '2')
User.create(email: 'user3@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '3', meta_type: 'Trainee')
Trainee.create(id: '3')

