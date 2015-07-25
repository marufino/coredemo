# db/seeds.rb

# SURVEY 1
survey = Survey.create(name: 'Sales Base')

block1 = survey.survey_blocks.create(category: 'Knowledge', weight: 30)
block1.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
block1.questions.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
block1.questions.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')

block2 = survey.survey_blocks.create(category: 'Skills', weight: 40)
block2.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')


block3 = survey.survey_blocks.create(category: 'Abilities', weight: 30)
block3.questions.create!(category: 'Planning', weight: 15, description: 'How well does the trainee plan for work')


# SURVEY 2
survey1 = Survey.create(name: 'Sales Advanced')

block1 = survey1.survey_blocks.create(category: 'Knowledge', weight: 30)
block1.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
block1.questions.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
block1.questions.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')

block2 = survey1.survey_blocks.create(category: 'Skills', weight: 40)
block2.questions.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')


block3 = survey1.survey_blocks.create(category: 'Abilities', weight: 30)
block3.questions.create!(category: 'Planning', weight: 15, description: 'How well does the trainee plan for work')


# OBSERVERS
User.create(email: 'observer1@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '1', meta_type: 'Observer')
obs1 = Observer.create(id: '1')
User.create(email: 'observer2@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '2', meta_type: 'Observer')
obs2 = Observer.create(id: '2')
User.create(email: 'observer3@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '3', meta_type: 'Observer')
obs3 = Observer.create(id: '3')


# TRAINEES
User.create(email: 'user1@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '1', meta_type: 'Trainee')
t1 = Trainee.create(id: '1')
User.create(email: 'user2@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '2', meta_type: 'Trainee')
t2 = Trainee.create(id: '2')
User.create(email: 'user3@ncsu.edu', password: 'password', password_confirmation: 'password', meta_id: '3', meta_type: 'Trainee')
t3 = Trainee.create(id: '3')


# PROJECT 1
project1 = Project.create(name: 'Advanced Project')
project1.observers << [obs1,obs2]

ass1 = project1.assignments.create(id: '1', date: '2015-07-23')
ass1.trainees << [t1,t3]
ass1.surveys << survey1

ass2 = project1.assignments.create(id: '2', date: '2015-08-23')
ass2.trainees << [t1,t2,t3]
ass2.surveys << survey1


# PROJECT 2
project2 = Project.create(name: 'Base Project')
project2.observers << [obs3]

ass3 = project2.assignments.create(id: '3', date: '2015-05-23')
ass3.trainees << [t1]
ass3.surveys << survey


