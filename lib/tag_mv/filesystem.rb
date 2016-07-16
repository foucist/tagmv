require 'fileutils'

module TagMv
  class Filesystem
    @root = File.expand_path('~/t')
    class << self
      attr_accessor :root
    end

    attr_accessor :tags, :files
    def initialize(opts={})
      @tags =  opts[:tags].map {|t| scrub_tag(t) }
      @files = opts[:files].map {|f| File.expand_path(f) }#.select {|f| File.exist?(f) }
    end

    def scrub_tag(tag)
      # only keep legit file characters & remove trailing periods
      tag.gsub(/[^0-9A-Za-z\.\-\_]|[\.]+$/, '')
    end

    def tree
      @tree ||= TagMv::Tree.scan_tree_entries
    end

    def update_tree
      tree.with(tags: tags, files: files)
    end

    def move_tree # run once..
      update_tree
      tree.entries.each {|x|  TagMv::Filesystem.new(x).transfer }
    end

    def tag_order
      tree.tag_order
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
    end

    def transfer
      prepare_dir && move_files
    end
  end
end
