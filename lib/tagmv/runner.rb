module Tagmv
  module Runner
    extend self

    def reorder_files
      tree.entries.each do |entry|
        fs_options = options.merge(tags: entry.tags, files: entry.files, tag_order: tree.tag_order, reorder: true)
        Tagmv::Filesystem.new(fs_options).transfer
      end
    end

    def move_new_files
      tree.entries << Entry.new(options)
      fs_options = options.merge(tag_order: tree.tag_order)
      Tagmv::Filesystem.new(fs_options).transfer
    end

    def run
      reorder_files
      move_new_files
      Tagmv::PrunePath.prune_tag_dirs
    end

    private
    def tree
      @tree ||= Tagmv::Tree.scan_tree_entries
    end

    def options
      @options ||= Tagmv::Options.new.options
    end
  end
end
