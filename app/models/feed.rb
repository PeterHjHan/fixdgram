class Feed < ApplicationRecord
  belongs_to :feedable, polymorphic: true
  validates :feedable_type, uniqueness: { scope: :feedable_id }
end
