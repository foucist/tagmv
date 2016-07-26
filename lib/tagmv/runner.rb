module Tagmv
  module Runner
    extend self

    def add_new_entries
      tree.with(options)
    end

    def update_options
      @options.merge!(tag_order: tree.tag_order)
    end

    def move_files
      tree.entries.each do |entry|
        tfs = Tagmv::Filesystem.new(
          options.merge(tags: entry.tags, files: entry.files)
        )
        tfs.transfer
      end
    end

    def run
      add_new_entries
      update_options
      move_files
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
