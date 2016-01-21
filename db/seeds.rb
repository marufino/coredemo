# db/seeds.rb

# SURVEY 1
=begin
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
=end
u1 = User.create(first_name: 'Ed', last_name: 'Ross',title: 'Manager', email: 'observer1@ncsu.edu', password: 'password', password_confirmation: 'password', meta_type: 'Admin', avatar: File.open(File.join(Rails.root,'app', 'assets', 'images', 'users2.png')), confirmed_at: Date.today)

role1 = Role.create(name: 'admin')

# OBSERVERS
u1.roles << role1


# PROJECT 1
# project1 = Project.create(name: 'Advanced Project')
# project1.observers << [obs1,obs2]
#
# ass1 = project1.assignments.create(id: '1', date: '2015-07-23')
# ass1.trainees << [t1,t3]
# ass1.surveys << survey1
#
# ass2 = project1.assignments.create(id: '2', date: '2015-08-23')
# ass2.trainees << [t1,t2,t3]
# ass2.surveys << survey1
#
#
# # PROJECT 2
# project2 = Project.create(name: 'Base Project')
# project2.observers << [obs3]
#
# ass3 = project2.assignments.create(id: '3', date: '2015-05-23')
# ass3.trainees << [t1]
# ass3.surveys << survey


