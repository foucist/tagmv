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

  class Entry
    attr_reader :file, :tags
    def initialize(file, tags)
      @file = file
      @tags = tags
    end
  end

  class TreeFS
    attr_accessor :entries
    def initialize(entries = [])
      @entries = entries
    end

    def self.regex_tags_in_path
      /\/\K.+?(?=\.\/)/
    end

    def self.regex_path_has_file
      /#{regex_tags_in_path}.*[^\.]$/
    end

    def self.tags(file)
      raise StandardError.new('Invalid file path given') unless file[/^#{TagFS.root}/]
      file[TagFS.root.length..-1].scan(regex_tags_in_path).reject {|x| x =~ /\//}
    end

    def self.scan_tree_entries
      files = Find.find(TagFS.root).select {|x| x =~ regex_path_has_file }
      tree = TreeFS.new
      files.map do |file|
        next if file =~ /\/.+\.\/[^.]+\/.+\./  # break when /dev./oh/blah./foo
        tree.entries << Entry.new(file,tags(file))
      end
      tree
    end

    # Find.find('.').select {|x| x =~ /([^\/]+\/)*([^\/]+\/)*\.\/.*/}
    # {"dev."=>{"book."=>{"javascript."=>{"Secrets_of_the_Javascript_Ninja.pdf"=>{}}, "ruby."=>{"rails_antipatterns.pdf"=>{}}}, "ruby."=>{"oh"=>{}, "yo_tag"=>{}}}}
    def self.scan_tree_hash
      Dir.chdir(TagFS.root)
      Dir["**/**./*"].inject({}) do |hash,path|
        tree = hash
        path.split("/").each do |n|
          tree[n] ||= {}
          tree = tree[n]
          break if n[-1] != "."
        end
        hash
      end
    end

  end

end
