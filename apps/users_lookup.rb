require_relative '../requests/UsersLookup'

require 'trollop'

USAGE = %Q{
users_lookup: returns list of users for given list of user_id's or screen_names's.

Usage:

  ruby users_lookup.rb <options> <user_ids/sceen_names>

  <user_id>: A comma-separated list of User IDs.
  <screen_name>: A comma-separated list of User Screen Name

The following options are required:

  --params: An OAuth Properties File
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "users_lookup 0.1 (c) 2015 Kenneth M. Anderson; Updated by Max Harris"
    banner USAGE
    opt :props, "OAuth Properties File", options
    opt :identifiers, "User Screen Names or ids"
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:identifiers] = ARGV[0]
  puts opts[:identifiers]

  if opts[:identifiers] == nil
    Trollop::die :props, "must specify at least 1 screen_name"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  # check if it's a screen name vs an id
  if (input[:identifiers].split(",").first.to_i.to_s.size == input[:identifiers].split(",").first.size)
    params = { user_id: input[:identifiers] }
  else
    params = { screen_name: input[:identifiers] }
  end
  data   = { props: input[:props] }
  args   = { params: params, data: data }

  users_data = UsersLookup.new(args)
  puts "Retrieving users for user_id #{params[:user_id]}" if !params[:user_id].nil?
  puts "Retrieving users for screen_name #{params[:screen_name]}" if !params[:screen_name].nil?

  users_data.collect do |user|
    puts "#{user}\n"
    puts "#{user.size} users retrieved.\n"
  end

  puts "DONE."
end