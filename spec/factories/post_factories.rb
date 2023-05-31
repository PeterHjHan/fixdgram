FactoryBot.define do
  factory :post do
    title { Faker::Movie.title }
    description { Faker::Movie.quote }
  end
end