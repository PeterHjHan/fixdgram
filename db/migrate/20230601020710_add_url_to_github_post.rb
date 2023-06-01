class AddUrlToGithubPost < ActiveRecord::Migration[7.0]
  def change
    add_column :github_posts, :url, :string, null: true
  end
end
