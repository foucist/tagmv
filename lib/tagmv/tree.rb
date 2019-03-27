require 'find'

module Tagmv
  class Tree
    attr_accessor :entries
    def initialize(entries = [])
      @entries = entries
    end

    def with(opts)
      entries << Entry.new(opts)
    end

    def tag_counts
      entries.map {|x| x.tags }.flatten.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
    end

    def tag_order
      tag_counts.to_a.sort_by{|x| [-x.last, x.first]}.map {|x| x.first }
    end


    def self.false_tag_regex
      # detect when there's a false tag i.e. tag2. in path/to/tag1./not_a_tag/tag2./
      /\/.+\-\/[^.]+\/.+\-/
    end
    def self.tags_in_path_regex
      /[^(\.|\-)\/]\K.+?(?=\-\/)/
    end

    def self.path_has_file_regex
      /#{tags_in_path_regex}.*[^\-]$/
    end

    def self.tags(file)
      raise StandardError.new('Invalid file path given') unless file[/^#{Filesystem.root}/]
      file[Filesystem.root.length..-1].scan(tags_in_path_regex).reject {|x| x =~ /\//}
    end

    def self.empty_dirs
      files = Find.find(Filesystem.root).select {|x| x =~ path_has_file_regex }
      tree = Tree.new
      files.map do |file|
        next if file =~ false_tag_regex
        tree.with(files: [file], tags: tags(file))
      end
      tree
    end

    def self.scan_tree_entries
      files = Find.find(Filesystem.root).select {|x| x =~ path_has_file_regex }
      tree = Tree.new
      files.map do |file|
        next if file =~ /\/.+\-\/[^-]+\/.+\-/  # break when /dev./oh/blah./foo
        tree.with(files: [file], tags: tags(file))
      end
      tree
    end

    # only gets existing tree, doesn't build an accurate tree based on all the tag counts etc..
    # Find.find('.').select {|x| x =~ /([^\/]+\/)*([^\/]+\/)*\.\/.*/}
    # {"dev."=>{"book."=>{"javascript."=>{"Secrets_of_the_Javascript_Ninja.pdf"=>{}}, "ruby."=>{"rails_antipatterns.pdf"=>{}}}, "ruby."=>{"oh"=>{}, "tagmv"=>{}}}}
    def self.scan_tree_hash
      Dir.chdir(Filesystem.root)
      
      # reject /dev-/-, /dev-/j-/ and /dev-/notag/tag-
      paths = Dir["**/*"].delete_if {|x| /\/(.*[^-]\/|[^\/]{0,1}?-)/ =~ x}
      paths.inject({}) do |hash,path|
        tree = hash
        path.split("/").each do |n|
          tree[n] ||= {}
          tree = tree[n]
          break if n[-1] != "-"
        end
        hash
      end
    end
  end

end
