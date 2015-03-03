require_relative '../core/TwitterRequest'

class ListsMemberships < TwitterRequest

  def initialize(args)
    super args
    params[:count] = 1000
    @count = 0
  end

  def request_name
    "ListsMemberships"
  end

  def twitter_endpoint
    "/lists/memberships"
  end

  def url
    'https://api.twitter.com/1.1/lists/memberships.json'
  end

  def success(response)
    lists = JSON.parse(response.body)['lists']
    @count += lists.size
    log.info("#{lists.size} list(s) received.")
    log.info("#{@count} total list(s) received.")
    yield lists
  end

  def error(response)
    if response.code == 404
      puts "No information found at specified url"
      return
    end
    super
  end

end
