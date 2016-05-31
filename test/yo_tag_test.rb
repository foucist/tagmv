require 'test_helper'
require 'pry'

class YoTagTest < Minitest::Test
  def before 
    @dir = Dir.mktmpdir
    YoTag::TagFS.root = @dir
  end

  def after
    FileUtils.remove_entry @dir
  end

  def test_that_it_has_a_version_number
    refute_nil ::YoTag::VERSION
  end

  def test_it_uses_root_for_target_dir
    dir = '/tmp/foobar'
    YoTag::TagFS.root = dir
    tfs = YoTag::TagFS.new('a')
    assert tfs.target_dir == dir + '/a'
  end

  def test_it_makes_tag_dirs
    before

    tags = ['a', 'b', 'c']
    tfs = YoTag::TagFS.new(tags)

    before = File.exist?(tfs.target_dir)
    assert_equal false, before

    tfs.prep_dirs
    assert File.exist?(tfs.target_dir)

    after
  end

  def test_it_moves_file_to_tag_dirs
    before
    tags = ['a', 'b', 'c']

    file = File.join(@dir, 'timestamp')
    assert FileUtils.touch(file)

    tfs = YoTag::TagFS.new(tags, file)
    tfs.move_file
    assert File.exist?(File.join(tfs.target_dir, 'timestamp'))

    after
  end

  def test_it_moves_directory_to_tag_dirs
    #FileUtils.mv Dir.glob('test*.rb'), 'test'
  end
  def test_it_moves_multiple_things_to_tag_dirs
  end

  def test_tag_lookup
  end

  def test_extract_tags_from_path
    path = "/home/test/t/./dev./book./ruby./oh/shit./rails_antipatterns.pdf"
    root = "/home/test/t/"
    tags = path[root.length..-1].scan(YoTag::Tree::regex_tags_in_path).reject {|x| x =~ /\//}
    assert tags == ["dev", "book", "ruby"]
  end

  def test_return_valid_paths
    all_paths = [".", "./.hidden", "./dev", "./dev/book", "./dev/book/javascript", "./dev/book/javascript/Secrets_of_the_Javascript_Ninja.pdf", "./dev/book/ruby", "./dev/book/ruby/rails_antipatterns.pdf", "./dev/ruby", "./dev/ruby/yo_tag", "./dev.", "./dev./book.", "./dev./book./javascript.", "./dev./book./javascript./Secrets_of_the_Javascript_Ninja.pdf", "./dev./book./ruby.", "./dev./book./ruby./rails_antipatterns.pdf", "./dev./ruby.", "./dev./ruby./yo_tag"]

    results = all_paths.select {|x| x =~ YoTag::Tree::regex_path_has_file }
    valid = ["./dev./book./javascript./Secrets_of_the_Javascript_Ninja.pdf", "./dev./book./ruby./rails_antipatterns.pdf", "./dev./ruby./yo_tag"]
    assert results == valid
  end

  def build_test_tree
    files = ["dev./book./ruby./rails_antipatterns.pdf", "dev./ruby./yo_tag/", "dev./book./javascript./Secrets_of_the_Javascript_Ninja.pdf", "dev./ruby./oh/snap./foobar"]
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

  def test_tree_scan
    before
    build_test_tree
    tree = YoTag::Tree.scan_tree
    assert_equal [["dev", "book", "javascript"], ["dev", "book", "ruby"], ["dev", "ruby"]], tree.entries.map {|x| x.tags }.uniq
    after
  end

end
