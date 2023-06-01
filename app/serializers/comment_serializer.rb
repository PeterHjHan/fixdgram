class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :description, :created_at
  attribute :commentable_id, key: :post_id
  belongs_to :user
  
  class UserSerializer < ActiveModel::Serializer
    attributes :email, :average_rating, :first_name, :last_name
    attribute :cached_weighted_average, key: :average_rating
  end
end
