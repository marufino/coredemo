# db/seeds.rb

Todo.create!(title: 'grocery shopping', notes: 'pickles, eggs, red onion')
Todo.create!(title: 'wash the car')
Todo.create!(title: 'register kids for school', notes: 'Register Kira for Ruby Junior High and Caleb for Rails High School')
Todo.create!(title: 'check engine light', notes: 'The check engine light is on in the Tacoma')
Todo.create!(title: 'dog groomers', notes: 'Take Pinky and Redford to the groomers on Wednesday the 23rd')

Question.create!(category: 'Market Insight', weight: 15, description: 'How well versed is the trainee in the Market')
Question.create!(category: 'Product Knowledge', weight: 25, description: 'How well does the trainee know the product')
Question.create!(category: 'Trends', weight: 10, description: 'How aware is the trainee in industry trends')

SurveyBlock.create!(category: 'Knowledge', weight: 30)
SurveyBlock.create!(category: 'Skills', weight: 40)
SurveyBlock.create!(category: 'Abilities', weight: 30)
