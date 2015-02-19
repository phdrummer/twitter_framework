require_relative '../core/TwitterRequest'

class Favorites < TwitterRequest

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
    puts favorites
    # puts favorites
    # test = []
    # for i in 0..favorites.length
    #   test << favorites[i]["text"]
    # end
    # puts test[0]
    log.info("#{favorites.size} favorite tweets received.")
    yield favorites
  end

end
