Fabricator(:survey_block) do

  category { Faker::Company.buzzword }
  weight { Faker::Number.between(20,40) }
  questions(count: 5)

end