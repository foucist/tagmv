module TagMv
  class PrunePath
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def tag_dir?
      path =~ /\.$/ && path !~ TagMv::Tree.false_tag_regex
    end

    def empty_dir?
      FileTest.directory?(path) && Dir.entries(path) == ['.', '..']
    end

    def rmdir
      Dir.rmdir(path) if tag_dir? && empty_dir?
    end

    def self.prune_tag_dirs
      Find.find(TagMv::Filesystem.root).reverse_each do |path|
        TagMv::PrunePath.new(path).rmdir
      end
    end

  end
end
