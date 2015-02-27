require_relative '../requests/MentionsTimeline'

require 'trollop'

USAGE = %Q{
get_mentions: Retrieve most recent mentions for a given Twitter screen_name.

Usage:
  ruby /PATH/get_mentions.rb <options>
}

def parse_command_line

  options_props = {type: :string, required: true}
  options_trim  = {type: :boolean, required: false, default: false}

  opts = Trollop::options do
    version "get_mentions 0.1 (c) 2015 Kenneth M. Anderson; Updated by Edward Zhu"
    banner USAGE
    opt :props, "OAuth Properties File", options_props
    opt :trim, "Trim User Object in Output", options_trim
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { trim_user: input[:trim].to_s }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = MentionsTimeline.new(args)

  puts "Collecting most recent mentions of authenticating user."
  puts "Trimming User Objects in Output: #{params[:trim_user].upcase}"

  File.open('mentions.json', 'w') do |f|
    twitter.collect do |mentions|
      mentions.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "DONE."

end
