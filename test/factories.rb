FactoryGirl.define do
  factory :artist do
    sequence(:name){ |n| "artist-#{n}" }
  end

  factory :registration do
    email 'customer@example.com'
    quantity 1
    phone_number '3157949887'
    event
  end

  factory :living_social_code do
    bucket "two"
    type "text"
  end

  factory :event do
    sequence(:title){ |n| "Test event #{n}" }
    from { 24.hours.from_now }
    to { 26.hours.from_now }
    seats 10
    seat_cost 45
  end

  factory :page do
    name 'only page'
    body '# Page'
  end
end
