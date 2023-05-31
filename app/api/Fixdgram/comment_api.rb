module Fixdgram
  class CommentAPI < Grape::API
    desc 'CRUD operations for comments on a user'

    before { authenticate! }

    resources :comments do

      desc 'create a comment'
      params do
        requires :data, type: Hash do
          requires :post_id, type: String
          requires :description, type: String
        end
      end
      post do
        post_id = params[:data][:post_id]
        description = params[:data][:description]
        post = Post.find_by_id(post_id)

        comment = post.comments.create(description: description, user: current_user)
  
        FeedCreatorService.new(model: comment, user: current_user).call

        success_response(data: comment)
      end

      desc 'destroy comment'
      delete ':comment_id' do
        comment_id = params[:comment_id]
        comment = Comment.find(comment_id)

        authorize! :destroy, comment
        
        comment.destroy!
        success_response(statusCode: 204, data: { id: comment.id })
      end
    end
  end
end