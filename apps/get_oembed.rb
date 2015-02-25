require_relative '../requests/StatusesOembed'

require 'trollop'

USAGE = %Q{
get_oembed: returns embeddable HTML for a given tweet.

Usage:

  ruby get_oembed.rb <options> <id>

  <id>: A Tweet ID.

The following options are required:

  --params: An OAuth Properties File
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_oembed 0.1 (c) 2015 Kenneth M. Anderson; Updated by Forrest Tagg Ridler"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:id] = ARGV[0]

  if opts[:id] == nil
    Trollop::die "You must supply a tweet ID"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { id: input[:id] }
  data   = { props: input[:props] }

  args   = { params: params, data: data }

  tweet = StatusesOembed.new(args)

  puts "Getting HTML for tweet id '#{input[:id]}'"

  File.open('tweet.html', 'w') do |f|
    tweet.collect do |tweet|
      f.puts "#{tweet}\n"
    end
  end

  puts "DONE."

end
