class API < Grape::API
  require 'grape/active_model_serializers'
  include Grape::Formatter::ActiveModelSerializers
  helpers ResponseHelpers, UserHelpers
  prefix 'api'
  format :json
  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ statusCode: 404, message: 'Unable to find comment'})
  end
  rescue_from CanCan::AccessDenied do |e|
    error!({ statusCode: 403, message: e})
  end

  mount Fixdgram::AuthenticationAPI
  mount Fixdgram::CommentAPI
  mount Fixdgram::FeedAPI
  mount Fixdgram::PostAPI
  mount Fixdgram::RatingAPI

end
