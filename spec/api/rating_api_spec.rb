require 'rails_helper'

describe Fixdgram::RatingAPI do

  let(:voters) { FactoryBot.create_list(:user, 5) }
  let(:user) { FactoryBot.create(:user) }

  context 'POST /api/ratings' do
    it 'updates the vote' do

      params = {
        data: {
          email: voters.first.email,
          rating: 4
        }
      }.to_json
      put '/api/users/ratings',
        headers: { 'Content-Type' => 'application/json', 'Authorization' => user.jti },
        params: params

      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq(200)
      expect(voters.first.votes_for.size).to eq(1)
    end
  end
end
