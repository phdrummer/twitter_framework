require_relative '../requests/ListSubscribers'

require 'trollop'

USAGE = %Q{
get_list_subscribers: Returns the subscribers of the specified list.

Usage:
  ruby get_list_subscribers.rb <options> <owner_screen_name> <list_slug>

  <owner_screen_name>: The screen name of the list owner.
  <list_slug>: The slug of the list.

  Example: 
  ruby get_list_subscribers.rb --props oath.properties twitterapi team

  Note: based off of implementation of get_list_members
  Also Note: Twitter REST API example has typo.  owner_screen_name must
    be "twitterapi," not "twitter"
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_list_subscribers 0.1 (c) 2015 Kenneth M. Anderson; Updated by Alexia Newgord"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:owner_screen_name] = ARGV[0]
  opts[:list_slug] = ARGV[1]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { slug: input[:list_slug], owner_screen_name: input[:owner_screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = ListSubscribers.new(args)

  puts "Collecting the subscribers of the specified list '#{input[:list_slug]}'"

  File.open('list_subscribers.txt', 'w') do |f|
    twitter.collect do |ids|
      ids.each do |id|
        f.puts "#{id}\n"
      end
    end
  end

  puts "DONE."

end
