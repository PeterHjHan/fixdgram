class GithubPost < ApplicationRecord
  belongs_to :user

  validates :event_id, presence: true,
end
