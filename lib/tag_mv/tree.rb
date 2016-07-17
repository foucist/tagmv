require 'find'

module TagMv
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


    def self.regex_tags_in_path
      /\/\K.+?(?=\.\/)/
    end

    def self.regex_path_has_file
      /#{regex_tags_in_path}.*[^\.]$/
    end

    def self.tags(file)
      raise StandardError.new('Invalid file path given') unless file[/^#{Filesystem.root}/]
      file[Filesystem.root.length..-1].scan(regex_tags_in_path).reject {|x| x =~ /\//}
    end

    def self.scan_tree_entries
      files = Find.find(Filesystem.root).select {|x| x =~ regex_path_has_file }
      tree = Tree.new
      files.map do |file|
        next if file =~ /\/.+\.\/[^.]+\/.+\./  # break when /dev./oh/blah./foo
        tree.with(files: [file], tags: tags(file))
      end
      tree
    end

    # only gets existing tree, doesn't build an accurate tree based on all the tag counts etc..
    # Find.find('.').select {|x| x =~ /([^\/]+\/)*([^\/]+\/)*\.\/.*/}
    # {"dev."=>{"book."=>{"javascript."=>{"Secrets_of_the_Javascript_Ninja.pdf"=>{}}, "ruby."=>{"rails_antipatterns.pdf"=>{}}}, "ruby."=>{"oh"=>{}, "tag_mv"=>{}}}}
    def self.scan_tree_hash
      Dir.chdir(Filesystem.root)
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
