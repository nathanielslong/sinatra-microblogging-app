require 'faker'

# loop for users

50.times do |n|
  User.new.tap do |user|
    user.email = Faker::Internet.email
    user.password = 'password'
    user.fname = Faker::Name.first_name
    user.lname = Faker::Name.last_name
    user.birthday = Faker::Date.between(40.years.ago, 20.years.ago)
    user.city = Faker::Address.city
    user.country = Faker::Address.country
    user.picture = Faker::Avatar.image
    user.save
  end

end

#loop for posts from these users

users = User.all

users.each do |user|
  3.times do
    user.posts.create(body: Faker::Hacker.say_something_smart,
                      genre: Faker::Pokemon.name,
                      album: Faker::Book.title,
                      artist: Faker::HarryPotter.character)
  end

end
