module Fixdgram
  class PostAPI < Grape::API
    resource :posts do 

      desc 'Create a Post'
      params do
        requires :data, type: Hash do
          requires :title, type: String
          requires :description, type: String
        end
      end
      post do
        authenticate!
        title = params[:data][:title]
        description = params[:data][:description]
        post = User.first.posts.create(title: title, description: description)
        success_response(data: post)
      end
    end
  end
end
