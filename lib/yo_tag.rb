require "yo_tag/version"
require 'fileutils'

module YoTag

  class TagFS
    @root = File.expand_path('~/t')
    class << self
      attr_accessor :root
    end

    attr_accessor :tags, :files
    def initialize(tags, files = nil)
      @tags = tags
      @files = files
    end

    def target_dir
      File.join(TagFS.root, *tags)
    end

    def prep_dirs
      FileUtils.mkdir_p(target_dir) 
    end

    def move_file
      prep_dirs && FileUtils.mv(files, target_dir)
    end
  end

  class Tree
    def self.regex_tags_in_path
      #http://idiosyncratic-ruby.com/11-regular-extremism.html
      /\.\/\K[^\/]+(?=\.\/)/
    end

    def self.regex_path_has_file
      /#{regex_tags_in_path}.*[^\.]$/
    end
  end

end
