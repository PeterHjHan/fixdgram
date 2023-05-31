class GithubService

  GITHUB_CREATE_REPO_TYPE = 'CreateEvent'
  GITHUB_PR_REPO_TYPE = 'PullRequestEvent'
  GITHUB_PUSH_COMMIT_TYPE = 'PushEvent'

  def initialize(username:)
    @username = username
    @connection = Faraday.new(url: "https://api.github.com/")
    @user = set_user
    @data = []
    @results = []
  end

  def call
    return unless @user
    get_events 
    return unless verify_github_user_exists?
    normalize_event_datas
    add_to_database
  end

  def add_to_database
    @data.each do |item|
      github_data = GithubPost.new(item)
      if github_data.save
        FeedCreatorService.new(model: github_data, user: @user).call
      else
        next
      end
    end
  end

  def get_events
    response = @connection.get("/users/#{@username}/events") do | request |
      request.headers['accept'] = 'application/vnd.github+json'
      request.headers['X-GitHub-Api-Version'] = '2022-11-28'
    end
    @results = JSON.parse(response.body)
  end

  def verify_github_user_exists?
    @results["message"]&.downcase != "not found'"
  end

  def normalize_event_datas
    @results.each do |event|
      params = {
        repo_name: event["repo"]["name"],
        user_id: @user.id,
        created_at: event["created_at"],
        event_id: event["id"],
      }
      case event["type"]
        when GITHUB_CREATE_REPO_TYPE
          params.merge!(normalize_new_repo_data)
        when GITHUB_PR_REPO_TYPE
          params.merge!(normalize_new_pr_data(event))
        when GITHUB_PUSH_COMMIT_TYPE
          params.merge!(normalize_push_commits_data(event))
        else 
          next
      end
      @data.push(params);
    end
  end

  def normalize_new_repo_data
    {
      request_type: 'new_repo',
      description: 'created new repo'
    }
  end

  def normalize_pr_data(data)
    if data["payload"]["action"] == 'opened'
      {
        request_type: 'new_pull_request',
        description: 'created new pull_request'
      }
    else
      {
        request_type: 'merge_pull_request',
        description: 'merged new pull_request'
      }
    end
  end

  def normalize_push_commits_data(data)
    {
      request_type: 'push_commits',
      description: "pushed #{data["payload"]["commits"].length} commits"
    }
  end

  def set_user
    @user = User.find_by(github_username: @username) || nil
  end
end


