require_relative '../requests/MentionsTimeline'

require 'trollop'

USAGE = %Q{
get_mentions: Retrieve most recent mentions for a given Twitter screen_name.

Usage:
  ruby get_mentions.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_mentions 0.1 (c) 2015 Kenneth M. Anderson"
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

  twitter = MentionsTimeline.new(args)

  puts "Collecting most recent mentions for '#{input[:screen_name]}'"

  File.open('mentions.json', 'w') do |f|
    twitter.collect do |mentions|
      mentions.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "DONE."

end
