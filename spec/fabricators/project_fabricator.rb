Fabricator(:project) do

  name { Faker::Company.catch_phrase + " Project"}
  description { Faker::Hacker.say_something_smart }

end