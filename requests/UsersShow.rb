require_relative '../core/TwitterRequest'

class UsersShow < TwitterRequest

  def request_name
    "UsersShow"
  end

  def twitter_endpoint
    "/users/show/:id"
  end

  def url
    'https://api.twitter.com/1.1/users/show.json'
  end

  def success(response)
    log.info("SUCCESS")
    users_data = JSON.parse(response.body)
    log.info("Data for User '#{data[:user]}' Received.")
    yield users_data
  end

  def error(response)
    if response.code == 404
      puts "No user found"
      return
    end
    super
  end

end
