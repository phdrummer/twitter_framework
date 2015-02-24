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
    log.info("#{mentions.size} mention(s) received.")
    log.info("#{@count} total mention(s) received.")
    yield mentions
  end

  def init_condition
    @num_success = 0
  end

  def condition
    @num_success < 16
  end

  def update_condition(mentions)
    if mentions.size > 0
      @num_success += 1
    else
      @num_success = 16
    end
  end

end
