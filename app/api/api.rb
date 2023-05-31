class API < Grape::API
  helpers ResponseHelpers, UserHelpers
  prefix 'api'
  format :json  

  mount Fixdgram::PostAPI
end
