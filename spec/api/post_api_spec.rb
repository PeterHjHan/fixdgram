require 'rails_helper'

describe Fixdgram::PostAPI do
  let(:user) { FactoryBot.create(:user_with_posts) }

  context 'POST /api/posts' do
    it 'fails to create a post without authentication' do
      post '/api/posts'
      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq 401
    end
    it 'fails to create a post without any data' do
      post '/api/posts', headers: { 'Content-Type' => 'application/json', 'Authorization' => user.jti }
      result = JSON.parse(response.body)
      expect(result["error"]).to be_truthy
    end
    it 'successfully creates a post' do
      params = {
        data: { description: "hello_world", title: "new post" }
      }.to_json
      post '/api/posts', 
        headers: { 'Content-Type' => 'application/json', 'Authorization' => user.jti },
        params: params

      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq(200)
      expect(result["data"]).to be_truthy
    end
  end

  context 'GET /api/posts/:post_id' do
    it 'returns the right data' do
      get "/api/posts/#{user.posts.first.id}",
        headers: { 'Content-Type' => 'application/json' }

      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq(200)
      expect(result.dig('data', 'user', 'id')).to eq(user.id)
    end

    it 'returns 404 when there is no post found' do
      get "/api/posts/f22",
        headers: { 'Content-Type' => 'application/json' }
      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq(404)
    end
  end
end