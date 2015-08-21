Fabricator(:question) do

  category { Faker::Company.buzzword }
  weight { Faker::Number.between(10,30) }
  description { Faker::Company.bs }

end