require 'fileutils'

module Tagmv
  class Filesystem
    @root = File.expand_path('~/t')
    class << self
      attr_accessor :root
    end

    attr_reader :tags, :files, :tag_order, :top_level_tags
    def initialize(opts={})
      @tags =  scrub_tags(opts[:tags])
      @files = opts[:files]
      @dry_run = opts[:dry_run]
      @tag_order = opts[:tag_order]
      @top_level_tags = opts[:top_level_tags]
    end

    def scrub_tags(tags)
      # only keep legit file characters & remove trailing periods, remove duplicates after
      bad_chars =  /^[\-]|[^0-9A-Za-z\.\-\_]|[\.]+$/
      tags.map {|t| t.gsub(bad_chars, '') }.uniq
    end

    def scrub_files(files)
      files.select do |file|
        path = File.expand_path(file)
        if File.exist?(path)
          path
        else
          puts "tmv: rename #{file} to #{target_dir}/#{File.basename(file)}: #{Errno::ENOENT.exception}"
          false
        end
      end
    end

    def tag_order
      top_level_tags | @tag_order
    end

    def tag_dirs
      (tag_order & tags).map {|x| x.gsub(/$/, '-') }
    end

    def target_dir
      File.join(Filesystem.root, *tag_dirs)
    end

    def prepare_dir
      FileUtils.mkdir_p(target_dir, options) 
    end

    def move_files
      FileUtils.mv(scrub_files(files), target_dir, options)
    rescue ArgumentError
    end

    def transfer
      prepare_dir && move_files
    end

    private
    def options
      if @dry_run
        {noop: true, verbose: true}
      else
        {}
      end
    end
  end
end
