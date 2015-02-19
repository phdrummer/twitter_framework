require_relative '../core/CursorRequest'

class ListMemberIds < CursorRequest

  def initialize(args)
    super args
    params[:count] = 5000
    @count = 0
  end

  def request_name
    "ListMemberIds"
  end

  def twitter_endpoint
    "/lists/members"
  end

  def url
    'https://api.twitter.com/1.1/lists/members.json'
  end

  def success(response)
    log.info("SUCCESS")
    ids = JSON.parse(response.body)["users"].map { |user| user["id"] }
    @count += ids.size
    log.info("#{ids.size} ids received.")
    log.info("#{@count} total ids received.")
    yield ids
  end

end
