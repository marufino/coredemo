Fabricator(:assignment) do

  date { Faker::Date.backward(30)}

end