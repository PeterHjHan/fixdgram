class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  has_many :feeds, as: :feedable, dependent: :destroy

  validates :description, presence: true
end
