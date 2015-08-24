Fabricator(:score) do

  knowledge { Faker::Number.between(0,100) }
  skills { Faker::Number.between(0,100) }
  abilities { Faker::Number.between(0,100) }
  total { Faker::Number.between(0,100) }

  completed { %w(t f).sample }
  completed_date { Faker::Date.backward(30)}


end