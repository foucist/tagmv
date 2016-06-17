require 'test_helper'
require 'pry'

class YoTagTest < Minitest::Test
  def before 
    @dir = Dir.mktmpdir
    YoTag::TagFS.root = @dir
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

  #def test_it_moves_directory_to_tag_dirs
    #FileUtils.mv Dir.glob('test*.rb'), 'test'
  #end

  #def test_it_moves_multiple_things_to_tag_dirs
  #end

  #def test_tag_lookup
  #end

  #def test_regex_tags_in_path
  #  path = "/home/test/t/./dev./book./ruby./oh/shit./rails_antipatterns.pdf"
  #  assert ["home/test/t/", "dev", "book", "ruby", "oh/shit"] == path.scan(YoTag::TagFS.regex_tags_in_path)
  #end

  def test_extract_tags_from_path  
    path = "/home/test/t/./dev./book./ruby./oh/shit./rails_antipatterns.pdf"
    root = "/home/test/t/"
    YoTag::TagFS.root = root
    tags = YoTag::TreeFS.tags(path)
    assert tags == ["dev", "book", "ruby"]
  end

  def test_select_valid_paths
    all_paths = [".", "./.hidden", "./dev", "./dev/book", "./dev/book/javascript", "./dev/book/javascript/Secrets_of_the_Javascript_Ninja.pdf", "./dev/book/ruby", "./dev/book/ruby/rails_antipatterns.pdf", "./dev/ruby", "./dev/ruby/yo_tag", "./dev.", "./dev./book.", "./dev./book./javascript.", "./dev./book./javascript./Secrets_of_the_Javascript_Ninja.pdf", "./dev./book./ruby.", "./dev./book./ruby./rails_antipatterns.pdf", "./dev./ruby.", "./dev./ruby./yo_tag"]

    results = all_paths.select {|x| x =~ YoTag::TreeFS::regex_path_has_file }
    valid = ["./dev./book./javascript./Secrets_of_the_Javascript_Ninja.pdf", "./dev./book./ruby./rails_antipatterns.pdf", "./dev./ruby./yo_tag"]
    assert results == valid
  end

  def test_tree_scan_entries
    before
    build_test_tree

    tree = YoTag::TreeFS.scan_tree_entries
    assert_equal [["dev", "book", "javascript"], ["dev", "book", "ruby"], ["dev", "ruby"]], tree.entries.map {|x| x.tags }.uniq

    after
  end

  def test_scan_tree_hash
    before
    build_test_tree

    result = YoTag::TreeFS.scan_tree_hash
    hash_tree = {"dev."=>{"book."=>{"javascript."=>{"Secrets_of_the_Javascript_Ninja.pdf"=>{}}, "ruby."=>{"rails_antipatterns.pdf"=>{}}}, "ruby."=>{"oh"=>{}, "yo_tag"=>{}}}}
    assert_equal hash_tree, result

    after
  end

end
