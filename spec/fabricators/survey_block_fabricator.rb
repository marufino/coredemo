Fabricator(:survey_block) do

  category { Faker::Company.buzzword }
  weight { Faker::Number.between(10,30) }
  questions(count: 5)

end