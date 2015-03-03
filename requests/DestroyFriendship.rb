require_relative '../core/TwitterRequest'

class DestroyFriendship < TwitterRequest

  def request_name
    "DestroyFriendship"
  end

  def twitter_endpoint
    "/friendships/destroy"
  end

  def url
    "https://api.twitter.com/1.1/friendships/destroy.json"
  end

  def success(response)
    log.info("SUCCESS")
    yield JSON.parse(response.body)
  end

  def authorization
    header = SimpleOAuth::Header.new("POST", url, escaped_params, props)
    { 'Authorization' => header.to_s }
  end

  def options
    options = super
    options[:method]  = :post
    options
  end

end
