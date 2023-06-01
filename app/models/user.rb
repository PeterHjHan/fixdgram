class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Pagy::Backend
  
  NUMBER_OF_ITEMS_PER_PAGE = 15

  acts_as_voter
  acts_as_votable cacheable_strategy: :update_columns

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :feeds, dependent: :destroy
  has_many :github_posts, dependent: :destroy

  def create_four_star_rating_post
    return false if votes_for.size < 20
    posts.create(title: "Passed 4 stars!") if cached_weighted_average.round(2) >= 4.0
  end

  def recent_feeds(page_params)
    begin
      query = feeds.includes(feedable: [:posts, :comments, :githubs]).order(created_at: :desc)
      data = []
      pagy, records = pagy(query, items: NUMBER_OF_ITEMS_PER_PAGE, page: page_params)

      records.each do |feed|
        serializer = ActiveModel::Serializer.serializer_for(feed.feedable)
        serialized_data = ActiveModelSerializers::SerializableResource.new(feed.feedable, serializer: serializer)
        data.push({
          created_at: feed.created_at,
          type: feed.feedable_type,
          data: serialized_data.as_json
        })
      end
      data
    rescue => error
      raise error
    end
  end
end
