module Fixdgram
  class PostAPI < Grape::API
    resource :posts do 

      namespace do
        before { authenticate! }
        desc 'Create a Post'
        params do
          requires :data, type: Hash do
            requires :title, type: String
            requires :description, type: String
          end
        end
        post do
          title = params[:data][:title]
          description = params[:data][:description]

          post = User.first.posts.create(title: title, description: description)

          FeedCreatorService.new(model: post, user: current_user).call
          
          success_response(data: post)
        end
      end

      desc 'get a specific post'
      params do
        requires :post_id, type: String
      end
      get '/:post_id' do
        post = Post.includes(:user, :comments).find(params[:post_id])
        data = post.as_json(include: [:user, :comments])
      
        options = { serializer: PostSerializer }
        serializable_resource = ActiveModelSerializers::SerializableResource.new(post, options)

        byebug

        data

        # success_response(data: data)
      end
    end
  end
end
