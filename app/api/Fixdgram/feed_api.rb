module Fixdgram
  class FeedAPI < Grape::API
    resources :feeds do

      desc 'get a user feeds'
      params do
        requires :email, type: String 
        optional :page, type: String
      end
      get do
        user = User.find_by(email: params[:email])

        begin
          GithubService.new(user: user, username: user.github_username).call if user.github_username?
          data = user.recent_feeds(params[:page] || 1)
          success_response(data: data)
        rescue => error
          error!({statusCode: 404, message: error})
        end
      end
    end
  end
end