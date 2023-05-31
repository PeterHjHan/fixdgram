class Post < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :feeds, as: :feedable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
end
