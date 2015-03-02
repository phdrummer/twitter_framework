require_relative '../core/TwitterRequest'

class ListsMemberships < TwitterRequest

  def initialize(args)
    super args
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
    lists =  JSON.parse(response.body)['lists']
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
