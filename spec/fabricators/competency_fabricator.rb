Fabricator(:competency) do

  name { Faker::Company.buzzword }
  description { Faker::Company.bs }

end