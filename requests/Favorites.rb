require_relative '../core/MaxIdRequest'

class Favorites < MaxIdRequest

  def initialize(args)
    super args
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
    log.info("#{favorites.size} favorite tweets received.")
    yield favorites
  end

  def init_condition
    @num_success = 0
  end

  def condition
    @num_success < 16
  end

  def update_condition(tweets)
    if tweets.size > 0
      @num_success += 1
    else
      @num_success = 16
    end
  end

end
