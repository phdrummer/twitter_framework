require_relative '../requests/Searches'

require 'trollop'

USAGE = %Q{
get_friends: Retrieve user ids followed by a given Twitter screen_name.

Usage:
  ruby get_friends.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_saved_searches 0.1 (c) 2015 Phil Leonowens"
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

  twitter = Searches.new(args)

  puts "Collecting the ids of the Twitter users followed by '#{input[:screen_name]}'"

  File.open('saved_searches.txt', 'w') do |f|
    twitter.collect do |searches|
      searches.each do |search|
        f.puts "#{search}\n"
      end
    end
  end

  puts "DONE."

end
