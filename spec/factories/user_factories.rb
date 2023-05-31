FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123'}
    
    factory :user_with_posts do
      transient do
        posts_count { 3 } # Number of posts to create
      end
      
      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end
end