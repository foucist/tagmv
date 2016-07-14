args = ["bin/1", "bin/console", "bin/setup", "bin/tagmv", "-t", "foo", "bar", "baz", "--help"]

VALID_OPTIONS = ["-t", "--tags"]


class ARGS
  DEFAULT_SWITCH = :files

  attr_reader :args

  def initialize(opts)
    @args = opts
    @current_switch = DEFAULT_SWITCH
  end

  def switch(arg)
    {"-t" => :tags}[arg]
  end

  def arg_type(arg)
    if arg =~ /^-/
      @current_switch = switch(arg)

      return :switches
    else
      @current_switch
    end
  end

  def to_hash
    args.group_by {|arg|  arg_type(arg) } 
    #=> {:files=>["bin/1", "bin/console", "bin/setup", "bin/tagmv"], :switches=>["-t", "--help"], :tags=>["foo", "bar", "baz"]}
  end
end


def split_args(args)

  opt_index = args.find_index {|x| x =~ /^-/}
  return unless opt_index
  before = args[0..opt_index-1]
  after  = args[opt_index+1..-1]
  [before, args[opt_index], after]
end

def parse(args)
  before_option, option, after_option = split_args(args)

  unless option
    raise StandardError.new('missing arguments?')
  end

  unless VALID_OPTIONS.include? option
    raise StandardError.new('invalid option') 
  end

  if after_option.grep(/^-/).any?
    raise StandardError.new('invalid tag argument? -') 
  end
  puts before_option.inspect
  puts after_option.inspect
end
parse(ARGV)
