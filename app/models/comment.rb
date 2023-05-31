class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  validates :description, presence: true
end
