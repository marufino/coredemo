Fabricator(:score) do

  completed { %w(t f).sample }
  #completed_date { Faker::Date.between(30.days.ago, 30.days.from_now)}


end