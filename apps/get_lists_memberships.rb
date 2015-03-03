require_relative '../requests/ListsMemberships'

require 'trollop'

USAGE = %Q{
get_lists_memberships: Retrieve lists that a given Twitter
                       screen_name is subscribed to.

Usage:
  ruby get_lists_memberships.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_lists_memberships 0.1 (c) 2015 Kenneth M. Anderson; Updated by Justin McBride"
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
  args   = { params: params, data: data }

  twitter = ListsMemberships.new(args)

  puts "Collecting the list memberships of the Twitter user '#{input[:screen_name]}'"

  File.open('lists_memberships.json', 'w') do |f|
    twitter.collect do |lists|
      lists.each do |list|
        f.puts "#{list.to_json}\n"
      end
    end
  end

  puts "DONE."

end
