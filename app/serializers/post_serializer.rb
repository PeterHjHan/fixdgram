class PostSerializer < ActiveModel::Serializer
  attributes :id, :description, :title, :created_at

  belongs_to :user
  class UserSerializer < ActiveModel::Serializer
    attributes :email, :cached_weighted_average
  end
end
