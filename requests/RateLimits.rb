require_relative '../core/TwitterRequest'

class RateLimits < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "RateLimits"
  end

  def url
    'https://api.twitter.com/1.1/application/rate_limit_status.json'
  end

  def twitter_endpoint
    "/application/rate_limit_status"
  end

  def success(response)
    log.info("SUCCESS")
    result    = nil
    all_rates = JSON.parse(response.body)['resources']
    # puts all_rates.inspect
    if all_rates.has_key?(params[:resources])
      resource_rates = all_rates[params[:resources]]
      if resource_rates.has_key?(data[:endpoint])
        rates  = resource_rates[data[:endpoint]]
        count  = rates['remaining']
        time   = Time.at(rates['reset']) + 10
        result = { count: count, time: time }
      else
        result = { error: "No rate information for #{data[:endpoint]}" }
      end
    else
      result = { error: "No rate information for #{params[:resources]}" }
    end
    yield result
  end

end
