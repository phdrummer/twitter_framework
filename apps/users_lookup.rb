require_relative '../requests/UsersLookup'

require 'trollop'

USAGE = %Q{
users_lookup: returns list of users for given list of user_id's or screen_names's.

Usage:

  ruby users_lookup.rb <options> <user_ids/sceen_names>
  ruby users_lookup.rb <options> screen_name:<screen_names>
  ruby users_lookup.rb <options> user_id:<user_ids>

  You may specify 'screen_name:' or 'user_id:' before the argument list
  If you don't, the script will make assume one or the other.
  This assumption will fail if you are aiming for screen_names, but the first in the list is all numbers
  It will incorrectly assume this is a uid.

  Note: Twitter allows the user to use one or the other or both.
        This script only allows screen_name or user_id explicitly per call.

  Examples:
  ~$ ruby users_lookup.rb --props=path_to/oauth.properties 1234,12345,etc...
  ~$ ruby users_lookup.rb --props=path_to/oauth.properties _maxharris,kenbod,etc... 

  script will automatically detect wether you are passing uids or screen_names,
  doesn't work if the first screen_name in the argument list is all numbers (some are),
  the script will incorrectly assume it is a uid.

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
    Trollop::die :props, "must specify at least 1 user_id or screen_name"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  # check if it's a screen name vs an id using a little ruby magic
  if input[:identifiers].split(":").first == "user_id"
    params = { user_id: input[:identifiers].split(":")[1] }

  elsif input[:identifiers].split(":").first == "screen_name"
    params = { screen_name: input[:identifiers].split(":")[1] }

  elsif(input[:identifiers].split(",").first.to_i.to_s.size == input[:identifiers].split(",").first.size)
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