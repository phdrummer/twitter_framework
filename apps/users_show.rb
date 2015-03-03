require_relative '../requests/UsersShow'

require 'trollop'

USAGE = %Q{
users_show: returns a user for given user_id or screen_name.

Usage:

  ruby users_show.rb <options> <user_id> || <screen_name>

  <user_id>     : A twitter user id.
  <screen_name> : A twitter screen name.


  Examples:
  $ ruby users_show.rb -p oauth.properties 1234
  $ ruby users_show.rb -p oauth.properties campbellalexs 

}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "users_show 0.1 (c) 2015 Kenneth M. Anderson; Updated by Alex Campbell"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "Must point to a valid oauth properties file"
  end

  opts[:identifiers] = ARGV[0]

  if opts[:identifiers] == nil
    Trollop::die "Must specify one user_id or screen_name"
  end

  opts
end


def parse_identifiers(input)
  if input.to_i.to_s.size == input.size #check if number
    return ["user_id", input]
  else
    return ["screen_name", input]
  end
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  id     = parse_identifiers(input[:identifiers])

  if id[0] == "user_id"
    params = { user_id: id[1] }
  else
    params = { screen_name: id[1] }
  end

  data   = { props: input[:props], user: id[1] }
  args   = { params: params, data: data }

  users_data = UsersShow.new(args)
  puts "Getting data for User '#{id[1]}'"

  users_data.collect do |user|
    puts "#{user}\n"
  end

  puts "DONE."
end
