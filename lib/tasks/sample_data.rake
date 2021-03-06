namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar")
  admin.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  users.each do |user|
    50.times { user.microposts.create!(content: Faker::Lorem.sentence(5)) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  leaders   = users[2..50]
  followers = users[3..40]
  leaders.each    { |leader| user.follow!(leader) }
  followers.each  { |follower| follower.follow!(user) }
end