namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
  end
end
    
    def make_users
    admin = User.create!(name: "Example User",
                 username: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
                 admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      username = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   username: username,
                   password: password,
                   password_confirmation: password)
    end
  end
