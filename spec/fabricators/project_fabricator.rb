Fabricator(:project) do

  name { Faker::Company.catch_phrase + " Project"}
  description { Faker::Hacker.say_something_smart }
  observers(count: 1)

end