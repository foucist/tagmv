module Tagmv
  module Runner
    extend self

    def tree
      @tree ||= Tagmv::Tree.scan_tree_entries
    end

    def update_tree
      opts = Tagmv::CommandLine.parse
      tree.with(opts)
    end

    def move_files
      tree.entries.each do |entry|
        tfs = Tagmv::Filesystem.new(tags: entry.tags, files: entry.files, tag_order: tree.tag_order, top_level_tags: @opts[:top_level_tags])
        tfs.transfer
      end
    end

    def run
      @opts = Tagmv::Config.new.load
      update_tree
      move_files
      Tagmv::PrunePath.prune_tag_dirs
    end
  end
end
