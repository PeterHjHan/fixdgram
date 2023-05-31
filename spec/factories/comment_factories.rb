FactoryBot.define do
  factory :comment do
    description { Faker::Movie.quote }
  end
end
