Fabricator(:test_scores) do

  starting { Faker::Number.between(0,100) }
  midterm { Faker::Number.between(0,100) }
  final { Faker::Number.between(0,100) }

end