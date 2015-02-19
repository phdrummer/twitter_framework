require_relative '../requests/Favorites'

require 'trollop'

USAGE = %Q{
get_favorites: Get the 20 most recent favorited tweets by the given user.

Usage:
  ruby get_favorites.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_favorites 0.1 (c) 2015 Josh Fermin"
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

  twitter = Favorites.new(args)

  puts "Collecting the favorite tweets of '#{input[:screen_name]}'"

  File.open('favorite_tweets_for_' + input[:screen_name] + '.json', 'w') do |f|
    twitter.collect do |favorites|
      favorites.each do |favorite|
        f.puts "#{favorite.to_json}\n"
      end
    end
  end

  puts "DONE."

end
