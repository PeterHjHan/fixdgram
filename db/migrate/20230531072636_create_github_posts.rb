class CreateGithubPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :github_posts do |t|
      t.string :request_type
      t.string :description
      t.string :repo_name
      t.belongs_to :user, index: true
      t.float :event_id, required: true
      t.timestamps
    end
  end
end
