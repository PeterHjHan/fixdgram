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

      if current_user.voted_for? user
        error!(statusCode: 400, message: 'Already rated')
      else
        user.vote_by voter: current_user, vote_weight: rating
        success_response(data: { message: 'Rated!'})
      end
    end
  end
end
