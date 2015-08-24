Fabricator(:survey) do


  name { Faker::Company.catch_phrase + " Scorecard"}
  description { Faker::Hacker.say_something_smart }
  survey_blocks(count: 3)

end