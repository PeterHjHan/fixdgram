class FeedCreatorService
  def initialize(model:, user:)
    @model = model
    @user = user
  end

  def call
    return false unless @model && @user
    return false if Feed.exists?(feedable: @model, user_id: @user.id)
    Feed.create(feedable: @model, user_id: @user.id)
  end
end