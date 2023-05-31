require 'rails_helper'

describe Fixdgram::CommentAPI do

  let(:user1) { FactoryBot.create(:user_with_posts) }
  let(:user2) { FactoryBot.create(:user) }

  context 'POST /api/comments' do
    it 'fails to create a comment without authentication' do
      post '/api/comments'
      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq 401
    end
    it 'fails to create a comment without any data' do
      post '/api/comments', headers: { 'Content-Type' => 'application/json', 'Authorization' => user1.jti }
      result = JSON.parse(response.body)
      expect(result["error"]).to be_truthy
    end
    it 'successfully creates a comment' do
      params = {
        data: { description: "hello_world", post_id: user1.posts.first.id}
      }.to_json
      post '/api/comments', 
        headers: { 'Content-Type' => 'application/json', 'Authorization' => user1.jti },
        params: params

      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq(200)
      expect(result["data"]).to be_truthy
    end
  end
  context 'DELETE /api/comments/:comment_id' do
    
    let!(:comment) { FactoryBot.create(:comment, user: user1, commentable: user1.posts.first)}

    it 'fails to destroy the comment if there is no comment' do
      delete "/api/comments/f123",
        headers: { 'Content-Type' => 'application/json', 'Authorization' => user1.jti }
      result = JSON.parse(response.body)
      expect(result["statusCode"]).to eq(404)
    end
    
    it 'fails to destroy the comment if you are not the comment owner' do
      delete "/api/comments/#{comment.id}",
        headers: { 'Content-Type' => 'application/json', 'Authorization' => user2.jti }

      result = JSON.parse(response.body)

      expect(result["statusCode"]).to eq(403)
    end

    it 'successfully destroys the comment' do
      delete "/api/comments/#{comment.id}",
      headers: { 'Content-Type' => 'application/json', 'Authorization' => user1.jti }

    result = JSON.parse(response.body)
    expect(result["statusCode"]).to eq(204)
    end
  end
end
