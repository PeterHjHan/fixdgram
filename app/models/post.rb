class Post < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
end
