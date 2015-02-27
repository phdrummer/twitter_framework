require_relative '../requests/UsersLookup'

require 'trollop'

USAGE = %Q{
users_lookup: returns list of users for given list of user_id's or screen_names's.

Usage:

  ruby users_lookup.rb <options> [user_ids|sceen_names]
  ruby users_lookup.rb <options> screen_names:<screen_names>
  ruby users_lookup.rb <options> user_ids:<user_ids>

  <user_ids>    : A comma-separated list of Twitter User IDs.
  <screen_names>: A comma-separated list of Twitter Screen Names.

  You may specify 'screen_names:' or 'user_ids:' before the argument list

  If you don't, the script will attempt to automatically detect the
  type of information passed to it. If the first item in the list
  if a number, the script will assume that you are passing
  user_ids. Otherwise, it will assume that you are passing
  screen names.

  Examples:
  $ ruby users_lookup.rb -p path_to/oauth.properties 1234,12345,...
  $ ruby users_lookup.rb -p path_to/oauth.properties _maxharris,kenbod,... 


The following options are required:

}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "users_lookup 0.1 (c) 2015 Kenneth M. Anderson; Updated by Max Harris"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:identifiers] = ARGV[0]

  if opts[:identifiers] == nil
    Trollop::die "must specify at least one user_id or screen_name"
  end

  opts
end

def unknown_error
  puts "ERROR: Unknown input list format."
  exit 1
end

def parse_identifiers(input_list)
  split_array = input_list.split(':')

  if split_array.size == 2
    list_type = split_array.first
    ids       = split_array.last

    if list_type == "user_ids" || list_type == "screen_names"
      return [list_type, ids]
    end
  elsif split_array.size == 1
    ids        = split_array.first
    components = ids.split(',')
    if components.first.to_i.to_s.size == components.first.size
      return ["user_ids", ids]
    else
      return ["screen_names", ids]
    end
  end

  unknown_error

end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  ids    = parse_identifiers(input[:identifiers])

  if ids[0] == "user_ids"
    params = { user_id: ids[1] }
    msg    = "Retrieving user objects for user_ids: #{ids[1]}"
  else
    params = { screen_name: ids[1] }
    msg    = "Retrieving user objects for screen_names: #{ids[1]}"
  end

  data   = { props: input[:props] }
  args   = { params: params, data: data }

  users_data = UsersLookup.new(args)
  puts msg

  users_data.collect do |user|
    puts "#{user}\n"
    puts "#{user.size} users retrieved.\n"
  end

  puts "DONE."
end
