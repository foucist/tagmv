require "yo_tag/version"
require 'fileutils'
require 'find'

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
      /\/\K.+?(?=\.\/)/
    end

    def self.regex_path_has_file
      /#{regex_tags_in_path}.*[^\.]$/
    end

    def self.tags(file)
      file[TagFS.root.length..-1].scan(regex_tags_in_path).reject {|x| x =~ /\//}
    end

    def self.scan_tree
      files = Find.find(TagFS.root).select {|x| x =~ regex_path_has_file }
      files.map { |file| tags(file) }
    end
  end

end
