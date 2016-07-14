require 'pry'

module YoTag
  class Client
    attr_accessor :tags, :files
    def initialize(opts={})
      @tags = opts[:tags]
      @files = opts[:files]
    end
  end
end
