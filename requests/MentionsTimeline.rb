require_relative '../core/MaxIdRequest'

class MentionsTimeline < MaxIdRequest

  def initialize(args)
    super args
    params[:count] = 200
    @count = 0
  end

  def request_name
    "MentionsTimeline"
  end

  def twitter_endpoint
    "/statuses/mentions_timeline"
  end

  def url
    'https://api.twitter.com/1.1/statuses/mentions_timeline.json'
  end

  def success(response)
    log.info("SUCCESS")
    mentions = JSON.parse(response.body)
    @count += mentions.size
    log.info("#{mentions.size} mention tweets received.")
    log.info("#{@count} total tweet(s) received.")
    yield mentions
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