require 'test_helper'
require 'pry'

class TreeTest < Minitest::Test
  def before 
    @dir = Dir.mktmpdir
    Tagmv::Filesystem.root = @dir
  end
  def after
    FileUtils.remove_entry @dir
  end

  def build_test_tree
    files = ["dev-/book-/ruby-/rails_antipatterns.pdf", "dev-/ruby-/tagmv/", "dev-/book-/javascript-/Secrets_of_the_Javascript_Ninja.pdf", "dev-/ruby-/oh/snap-/foobar", "dev-/-/wha-", "dev-/j-/who-"]
    files.each do |file|
      path = File.join(@dir, file)
      if file[-1] == "/"
        FileUtils.mkdir_p(path)
      else
        FileUtils.mkdir_p(File.dirname(path))
        FileUtils.touch(path)
      end
    end
  end

  def test_tag_counts
    tree = Tagmv::Tree.new
    def tree.entries
      entry = Struct.new(:tags)
      entries = 2.times.map { entry.new(["foo", "bar", "baz", "zoo"]) }
      entries << entry.new(["zoo"])
    end
    assert tree.tag_counts == {"foo"=>2, "bar"=>2, "baz"=>2, "zoo" =>3}
  end

  def test_tag_order
    tree = Tagmv::Tree.new
    def tree.tag_counts
      {"foo"=>4, "bar"=>4, "baz"=>4, "zoo" => 5}
    end
    assert tree.tag_order == ["zoo", "bar", "baz", "foo"]
  end

  #def test_tag_lookup
  #end

  #def test_regex_tags_in_path
  #  path = "/home/test/t/./dev-/book-/ruby-/oh/shit-/rails_antipatterns.pdf"
  #  assert ["home/test/t/", "dev", "book", "ruby", "oh/shit"] == path.scan(Tagmv::Filesystem.regex_tags_in_path)
  #end

  def test_extract_tags_from_path  
    path = "/home/test/t/./dev-/book-/ruby-/oh/shit-/rails_antipatterns.pdf"
    root = "/home/test/t/"
    Tagmv::Filesystem.root = root
    tags = Tagmv::Tree.tags(path)
    assert tags == ["dev", "book", "ruby"]
  end

  def test_select_valid_paths
    all_paths = ["-", "./.hidden", "./dev", "./dev/book", "./dev/book/javascript", "./dev/book/javascript/Secrets_of_the_Javascript_Ninja.pdf", "./dev/book/ruby", "./dev/book/ruby/rails_antipatterns.pdf", "./dev/ruby", "./dev/ruby/tagmv", "./dev-", "./dev-/book-", "./dev-/book-/javascript-", "./dev-/book-/javascript-/Secrets_of_the_Javascript_Ninja.pdf", "./dev-/book-/ruby-", "./dev-/book-/ruby-/rails_antipatterns.pdf", "./dev-/ruby-", "./dev-/ruby-/tagmv"]

    results = all_paths.select {|x| x =~ Tagmv::Tree.path_has_file_regex }
    valid = ["./dev-/book-/javascript-/Secrets_of_the_Javascript_Ninja.pdf", "./dev-/book-/ruby-/rails_antipatterns.pdf", "./dev-/ruby-/tagmv"]
    assert results == valid
  end

  def test_tree_scan_entries
    before
    build_test_tree

    tree = Tagmv::Tree.scan_tree_entries
    assert_equal [["dev", "book", "javascript"], ["dev", "book", "ruby"], ["dev", "ruby"]], tree.entries.map {|x| x.tags }.uniq

    after
  end

  def test_scan_tree_hash
    before
    build_test_tree

    result = Tagmv::Tree.scan_tree_hash
    hash_tree = {"dev-"=>{"book-"=>{"javascript-"=>{"Secrets_of_the_Javascript_Ninja.pdf"=>{}}, "ruby-"=>{"rails_antipatterns.pdf"=>{}}}, "ruby-"=>{"oh"=>{}, "tagmv"=>{}}}}
    assert_equal hash_tree, result

    after
  end

  def test_tag_entry_counts
  end

  def test_rebuild_tree
  end
end
