module ResponseHelpers
  extend Grape::API::Helpers

  def success_response(statusCode: 200, data:)
    { 
      statusCode: statusCode,
      data: data
    }
  end
end