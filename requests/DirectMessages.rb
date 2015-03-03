require_relative '../core/MaxIdRequest'

class DirectMessages < MaxIdRequest

  def initialize(args)
    super args
    params[:count] = 100
    @count = 0
  end

  def request_name
    "Searches"
  end

  def twitter_endpoint
    '/direct_messages'

  end

  def url
      'https://api.twitter.com/1.1/direct_messages.json'
  end

  def success(response)
    log.info("SUCCESS")
    searches = JSON.parse(response.body)
    @count += searches.size
    log.info("#{searches.size} message(s) received.")
    log.info("#{@count} total message(s) received.")
    yield searches
  end

  def init_condition
    @last_count = 1
  end

  def condition
    @last_count > 0
  end

  def update_condition(tweets)
    @last_count = tweets.size
  end

end
