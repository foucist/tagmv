require 'choice'

module Tagmv
  module CommandLine
    extend self

    Choice.options do
      header "A Directory-based Tagging Organizer"
      header ""
      header "Usage:"
      header "    $ tagmv file1 file2 directory1 directory2 -t tag1 tag2 tag3 -d"
      header ""
      header "Options:"

      footer ""
      footer "tagmv by #{Tagmv::AUTHORS.join(', ')} (#{Tagmv::HOMEPAGE})"

      option :dry_run do
        short '-d'
        long '--dry-run'
        desc 'Check to see what gets moved where'
      end

      option :reorder do
        short '-r'
        long '--reorder'
        desc 'Move all tagged files & directories into order of tag usage [default]'
      end

      option :skip_reorder do
        short '-s'
        long '--skip-reorder'
        desc "Skip reorder (for example: you are editing tagged files and don't want them moved around yet)"
      end

      option :tags do
        short '-t'
        long '--tags *tags'
        desc 'Tags for your files or directories, as many as you want'
      end
    end

    def parse
      return Choice.help if !Choice.choices[:reorder] && (Choice.choices.empty? || Choice.rest.empty?)

      opts = Hash.new
      opts[:files]   = Choice.rest
      opts[:dry_run] = Choice.choices[:dry_run]
      opts[:tags]    = Choice.choices[:tags]
      opts[:reorder] = Choice.choices[:reorder]
      opts[:skip_reorder]= Choice.choices[:skip_reorder]
      opts
    end
  end
end
