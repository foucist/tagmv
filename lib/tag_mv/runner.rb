module TagMv
  module Runner
    extend self

    def tree
      @tree ||= TagMv::Tree.scan_tree_entries
    end

    def update_tree
      opts = TagMv::CommandLine.parse
      tree.with(opts)
    end

    def move_files
      tree.entries.each do |entry|
        tfs = TagMv::Filesystem.new(tags: entry.tags, files: entry.files, tag_order: tree.tag_order)
        tfs.transfer
      end
    end

    def run
      update_tree
      move_files
      TagMv::PrunePath.prune_tag_dirs
    end
  end
end
