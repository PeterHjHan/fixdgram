class API < Grape::API
  helpers ResponseHelpers, UserHelpers
  prefix 'api'
  format :json  

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ statusCode: 404, message: 'Unable to find comment'})
  end
  rescue_from CanCan::AccessDenied do |e|
    error!({ statusCode: 403, message: e})
  end

  mount Fixdgram::PostAPI
end
