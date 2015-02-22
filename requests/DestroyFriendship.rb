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

	def authorization
	    params = { track: data[:terms].join(",") }
	    header = SimpleOAuth::Header.new("POST", url, params, props)
	    { "Authorization" => header.to_s }
  	end

  	#TODO: Add in functinality to destroy friendship based on screen name or user_id
  	def body
  		"screen_name=" + screen_name
  		# "user_id=" + user_id
  	end

  	def options
  		options = {}
  		options[:method] = :post
  		options[:authorization] = authorization
  		options[:body] = body
  		options
  	end 
end 
