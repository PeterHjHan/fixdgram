class GithubPost < ApplicationRecord
  has_many :feeds, as: :feedable, dependent: :destroy
  belongs_to :user

  validates :event_id, uniqueness: true
end
