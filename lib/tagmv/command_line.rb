require 'choice'

module Tagmv
  module CommandLine
    extend self

    Choice.options do
      header "\033[1m\033[32mtagmv\033[0m\033[0m: A Directory-based Tagging Organizer"
      header ""
      header "Options:"

      footer ""
      footer "tagmv by #{Tagmv::AUTHORS.join(', ')} (#{Tagmv::HOMEPAGE})"

      option :tags, :required => true do
        short '-t'
        long '--tags *tags'
        desc 'The hostname or ip of the host to bind to (default 127.0.0.1)'
      end
    end

    def parse
      return Choice.help if Choice.rest.empty?

      opts = Hash.new
      opts[:files] = Choice.rest
      opts[:tags]  = Choice.choices[:tags]
      opts
    end
  end
end
