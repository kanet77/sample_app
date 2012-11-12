FactoryGirl.define do
  factory :user do
    sequence(:name)  { Faker::Name.name }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation { |u| u.password }

	  factory :admin do
	  	admin true
	  end
  end
end
