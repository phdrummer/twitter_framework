require_relative '../core/StreamingTwitterRequest'

class DestroyFriendship < StreamingTwitterRequest

  def request_name
    "DestroyFriendship"
  end

  def twitter_endpoint
    "/friendships/destroy"
  end

  def url
    "https://api.twitter.com/1.1/friendships/destroy.json"
  end

  def authorization
    #params = { track: prepare_terms.join(",") }
    params = { track: data[:terms].join(",") }
    header = SimpleOAuth::Header.new("POST", url, params, props)
    { "Authorization" => header.to_s }
  end

  def body
    body = "screen_name=" + prepare_terms.join(",")
    puts body 
    body
  end

  def prepare_terms
    data[:terms].map { |term| prepare(term) }
  end

  def options
    options = {}
    options[:method]  = :post
    options[:headers] = authorization
    options[:body]    = body
    puts options
    options
  end

end
