class UserSerializer < ActiveModel::Serializer
  attributes :email, :average_rating, :first_name, :last_name
  attribute :cached_weighted_average, key: :average_rating
  
  has_many :comments
end
