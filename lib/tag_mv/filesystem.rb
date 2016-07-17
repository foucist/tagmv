require 'fileutils'

module TagMv
  class Filesystem
    @root = File.expand_path('~/t')
    class << self
      attr_accessor :root
    end

    attr_accessor :tags, :files, :tag_order
    def initialize(opts={})
      @tags =  opts[:tags].map {|t| scrub_tag(t) }
      @files = opts[:files].map {|f| File.expand_path(f) }.select {|f| File.exist?(f) }
      @tag_order = opts[:tag_order]
    end

    def scrub_tag(tag)
      # only keep legit file characters & remove trailing periods
      tag.gsub(/[^0-9A-Za-z\.\-\_]|[\.]+$/, '')
    end

    def tag_dirs
      (tag_order & tags).map {|x| x.gsub(/$/, '.') }
    end

    def target_dir
      File.join(Filesystem.root, *tag_dirs)
    end

    def prepare_dir
      FileUtils.mkdir_p(target_dir) 
    end

    def move_files
      FileUtils.mv(files, target_dir)
    rescue ArgumentError
    end

    def transfer
      prepare_dir && move_files
    end
  end
end
