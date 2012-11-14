FactoryGirl.define do
  factory :user do |u|
    sequence(:name)  { Faker::Name.name }
    sequence(:email) { Faker::Internet.email.gsub('@',".#{Time.now.usec}@").to_s }
    password "foobar"
    password_confirmation { |x| x.password }

	  factory :admin do
	  	admin true
	  end
  end

  factory :micropost do
    sequence(:content) { Faker::Lorem.sentence }
    user
  end
end
