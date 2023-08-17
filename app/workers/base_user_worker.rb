class BaseUserWorker < BaseWorker
  def execute(user_id, *args)
    super('User', user_id, *args)
  end

  private

  def user
    client
  end
end
