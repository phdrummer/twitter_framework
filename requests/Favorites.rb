require_relative '../core/MaxIdRequest'

class Favorites < MaxIdRequest

  def initialize(args)
    super args
    params[:count] = 200
    @count = 0
  end

  def request_name
    "Favorites"
  end

  def twitter_endpoint
    "/favorites/list"
  end

  def url
    'https://api.twitter.com/1.1/favorites/list.json'
  end

  def success(response)
    log.info("SUCCESS")
    favorites = JSON.parse(response.body)
    @count += favorites.size
    log.info("#{favorites.size} favorite tweets received.")
    log.info("#{@count} total tweet(s) received.")
    yield favorites
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
