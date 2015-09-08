Fabricator(:competency) do

  name { Faker::Company.buzzword }
  category { $categorynames.sample }
  description { Faker::Company.bs }
  coaching { Faker::Company.bs }

end