module UserHelpers
  extend Grape::API::Helpers

  def current_user
    @current_user = User.find_by(jti: headers["Authorization"]) || nil
  end

  def authenticate!
    error!({statusCode: 401, message: 'Incorrect credentials'}) if headers["Authorization"].blank?

    user = User.find_by(jti: headers["Authorization"])

    error!({statusCode: 401, message: 'Incorrect credentials'}) unless user
    
    current_user = user
    true
  end

  def authorize!(*args)
    Ability.new(current_user).authorize!(*args)
  end
end