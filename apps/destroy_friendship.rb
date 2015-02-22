require_relative '../requests/DestroyFriendship'

require 'trollop'

$continue = true

Signal.trap(:INT) do
  $continue = false
end

USAGE = %Q{
destroy_friendship: Allows the authenticating user to unfollow the user specified in the ID parameter.

Usage:
  ruby destroy_friendship.rb <options> <user>

  terms: The name of a file containing search terms, one per line.

  The terms must match the requirements documented here:
    https://dev.twitter.com/rest/reference/post/friendships/destroy

The following options are supported: 

-u : if you want to input a user_id
-s : if you want to input a screen_name
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "public_stream 0.1 (c) 2015 Kenneth M. Anderson"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts
end


if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line

  data   = { props: input[:props], user: load_terms(input[:user]) }

  args   = { params: {}, data: data }

  twitter = FilterTrackStream.new(args)

  puts "Unfollowing users with the following ids/user_names: "
  puts data[:terms]

end
