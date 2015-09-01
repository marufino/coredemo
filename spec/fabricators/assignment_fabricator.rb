Fabricator(:assignment) do

  date { Faker::Date.between(30.days.ago, 30.days.from_now)}

end