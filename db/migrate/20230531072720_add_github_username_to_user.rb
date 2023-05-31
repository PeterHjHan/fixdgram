class AddGithubUsernameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_username, :string, null: true
  end
end
