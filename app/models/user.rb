class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  acts_as_voter
  acts_as_votable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :posts, dependent: :destroy

  def create_four_star_rating_post
    return false if votes_for.size < 20
    posts.create(title: "Passed 4 stars!") if cached_weighted_average.round(2) >= 4.0
  end
end
