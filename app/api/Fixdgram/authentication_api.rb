module Fixdgram
  class AuthenticationAPI < Grape::API
    desc 'returns jwt token'

    params do
      requires :data, type: Hash do
        requires :email, type: String
        requires :password, type: String
      end
    end

    post :authentication do
      ERROR_MESSAGE = error!({statusCode: 403, message: 'User or password is not a match' })

      email = params[:data][:email]
      password = params[:data][:password]
      
      user = User.find_by_email(email)

      return ERROR_MESSAGE unless user
      
      user.valid_password?(password) ? 
        success_response(data: user.jti) : 
        ERROR_MESSAGE
    end
  end
end