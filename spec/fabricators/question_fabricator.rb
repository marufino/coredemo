Fabricator(:question) do

  category { (Competency.all.map{|c| c.name}).sample }
  weight { Faker::Number.between(10,30) }
  description { (Competency.all.map{|c| c.description}).sample }

end