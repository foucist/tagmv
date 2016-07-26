module Tagmv
  class Options
    attr_accessor :additions
    def initialize(opts = {})
      @additions = opts
    end

    def input
      Tagmv::CommandLine.parse || {}
    end

    def load_config
      Tagmv::Config.new.load
    end

    def options
      return if @options

      @options = load_config
      @options.merge(additions)
      @options.merge(input)
    end
  end
end
