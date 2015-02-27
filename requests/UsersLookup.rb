require_relative '../core/TwitterRequest'

class UsersLookup < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "UsersLookup"
  end

  def twitter_endpoint
    "/users/lookup"
  end

  def url
    'https://api.twitter.com/1.1/users/lookup.json'
  end

  def escaped_params
    params
  end

  def success(response)
    log.info("SUCCESS")
    users_data = JSON.parse(response.body)
    log.info("users data received.")
    yield users_data
  end

  def error(response)
    if response.code == 404
      puts "No users found"
      return
    end
    super
  end

end
