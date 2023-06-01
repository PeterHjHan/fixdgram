class GithubPostSerializer < ActiveModel::Serializer
  attributes :request_type, :repo_name, :description, :url
end
