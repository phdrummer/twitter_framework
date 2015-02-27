require_relative '../requests/MentionsTimeline'

require 'trollop'

USAGE = %Q{
get_mentions: Retrieve most recent mentions for a given Twitter screen_name.

Usage:
  ruby /PATH/get_mentions.rb <options> <trim_user>

  <trim_user>: When set to either true, t or 1, each tweet 
      returned in a timeline will include a user object 
      including only the status authors numerical ID.
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_mentions 0.1 (c) 2015 Edward Zhu"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:trim_user] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { trim_user: input[:trim_user] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = MentionsTimeline.new(args)

  puts "Collecting most recent mentions of myself. Trimming mentions:'#{input[:trim_user]}'"

  File.open('mentions.json', 'w') do |f|
    twitter.collect do |mentions|
      mentions.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "DONE."

end
