require_relative '../core/StreamingTwitterRequest'

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

  def body
    body = "screen_name=" + prepare_terms.join(",")
    puts body 
    body
  end

  def prepare_terms
    data[:terms].map { |term| prepare(term) }
  end

  def authorization
    header = SimpleOAuth::Header.new("POST", url, escaped_params, props)
    { 'Authorization' => header.to_s }
  end

  def options
    options = {}
    options[:method]  = :post
    options[:headers] = authorization

    request_params = {}
    escaped_params.keys.each do |key|
      request_params[key] = escaped_params[key] if include_param?(key)
    end
    options[:params]  = request_params
    puts options
    options
  end

end
