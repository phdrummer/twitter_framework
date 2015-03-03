require_relative '../requests/DestroyFriendship'

require 'trollop'

USAGE = %Q{
destroy friendships: Unfollow the given screen_name

Usage:

  ruby destroy_friendship.rb --props oauth.properties <screen_name>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "destroy_friendship 0.1 (c) 2015 Kenneth M. Anderson; Updated by Alex Tsankov"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = DestroyFriendship.new(args)

  puts "Unfollowing: '#{input[:screen_name]}'"

  twitter.collect do |user|
    puts "#{user['screen_name']} with id '#{user['id']}' unfollowed."
  end

end
