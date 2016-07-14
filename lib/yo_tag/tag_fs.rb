require 'fileutils'

module YoTag
  class TagFS

    @root = File.expand_path('~/t')
    class << self
      attr_accessor :root
    end

    attr_accessor :tags, :files
    def initialize(opts={})
      @tags = opts[:tags]
      @files = opts[:files]
    end

    def tag_order
      Tree.tags
    end

    #def tags
    #  tag_order & tags
    #end

    def target_dir
      File.join(TagFS.root, *tags)
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
