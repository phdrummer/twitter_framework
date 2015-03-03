require_relative '../requests/DirectMessages'

require 'trollop'

USAGE = %Q{
get_friends: Retrieve directMessages preceded by username.

Usage:
  ruby get_dms.rb <options>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_dms 0.1 (c) 2015 Phil Leonowens"
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
  data   = { props: input[:props] }
  params = {}
  args     = { params: params, data: data }

  twitter = DirectMessages.new(args)

  puts "Collecting your direct messages"

  File.open('dms.txt', 'w') do |f|
    twitter.collect do |searches|
      searches.each do |search|
        f.puts "#{search['sender_screen_name']}\n"
        f.puts "#{search['text']}\n"
      end
    end
  end

  puts "DONE."

end
