Fabricator(:user) do

  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  title { Faker::Name.title }
  email { Faker::Internet.email }
  phone { Faker::PhoneNumber.phone_number}
  password 'password'
  password_confirmation 'password'
  avatar { Faker::Avatar.image }

end