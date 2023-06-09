class API < Grape::API
  helpers ResponseHelpers, UserHelpers
  prefix 'api'
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ statusCode: 404, message: 'Unable to find information'})
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
