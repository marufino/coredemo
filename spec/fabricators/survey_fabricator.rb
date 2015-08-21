Fabricator(:survey) do


  name { Faker::Company.catch_phrase }
  description { Faker::Hacker.say_something_smart }
  survey_blocks(count: 3)

end