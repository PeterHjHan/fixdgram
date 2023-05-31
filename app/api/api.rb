class API < Grape::API
  prefix 'api'
  format :json  
  
  mount Fixdgram::PostAPI
end
