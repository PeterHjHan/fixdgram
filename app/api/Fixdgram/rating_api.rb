module Fixdgram
  class RatingAPI < Grape::API

    before do
      authenticate!
    end

    params do
      requires :data, type: Hash do
        requires :email, type: String
        requires :rating, type: String
      end
    end

    desc 'upserts ratings to a person'
    put :ratings do
      email = params[:data][:email]
      rating = params[:data][:rating]
      user = User.find_by_email(email)

      error!({statusCode: 400, message: 'Rating must be between 1 and 5'}) if (1..0).include?(rating.to_i)

      # with acts_as_votable gem, they do not have a simple update vote
      # the workaround is to destroy and then create again
      user.unliked_by current_user if current_user.voted_for? user
      user.vote_by voter: current_user, vote_weight: rating
      success_response(data: { message: 'Rated!'})
    end
  end
end
