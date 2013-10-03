FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:username) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  
  factory :trip do
    
    trip_id  "2"
    title    "xyz"
    destination  "vizag"
    destination_lat  "20"
    destination_lng  "10"
    start_date  "18-06-1991"
    end_date  "20-06-1991"
    
    user
    
    
  end
end