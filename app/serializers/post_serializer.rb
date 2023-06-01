class PostSerializer < ActiveModel::Serializer
  attributes :id, :description, :title, :created_at
  belongs_to :user
  has_many :comments
end
