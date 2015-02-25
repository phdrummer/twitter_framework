require_relative '../requests/ListMemberIds'

require 'trollop'

USAGE = %Q{
get_list_members: Retrieve members of a given Twitter list.

Usage:
  ruby get_list_members.rb <options> <owner_screen_name> <list_slug>

  <owner_screen_name>: The screen name of the list owner.
  <list_slug>: The slug of the list.
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_list_members 0.1 (c) 2015 Kenneth M. Anderson; Updated by David Aragon"
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

  twitter = ListMemberIds.new(args)

  puts "Collecting the ids of the Twitter users that are members of list '#{input[:list_slug]}'"

  File.open('list_member_ids.txt', 'w') do |f|
    twitter.collect do |ids|
      ids.each do |id|
        f.puts "#{id}\n"
      end
    end
  end

  puts "DONE."

end
