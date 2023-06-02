require 'rails_helper'

describe Fixdgram::RatingAPI do

  let(:voters) { FactoryBot.create_list(:user, 21) }
  let(:user) { FactoryBot.create(:user) }

  context 'PUT /api/ratings' do
    it 'updates the vote' do

      params = {
        data: {
          email: user.email,
          rating: 4
        }
      }.to_json
      put '/api/users/ratings',
        headers: { 'Content-Type' => 'application/json', 'Authorization' => voters.first.jti },
        params: params

      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq(200)
      expect(user.votes_for.size).to eq(1)
    end

    it 'creates the average post vote for the user' do
      voters.each do |voter|
        params = {
          data: {
            email: user.email,
            rating: 4.2
          }
        }.to_json
        put '/api/users/ratings',
          headers: { 'Content-Type' => 'application/json', 'Authorization' => voter.jti },
          params: params
      end

      expect(user.votes_for.size).to eq(21)
      expect(user.has_4_star_rating_post).to be_truthy
    end

    it 'does not create the average post vote for the user' do
      voters.each do |voter|
        params = {
          data: {
            email: user.email,
            rating: 3.8
          }
        }.to_json
        put '/api/users/ratings',
          headers: { 'Content-Type' => 'application/json', 'Authorization' => voter.jti },
          params: params
      end

      expect(user.votes_for.size).to eq(21)
      expect(user.has_4_star_rating_post).to be_falsy
    end
  end
end
