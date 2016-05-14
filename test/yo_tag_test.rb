require 'test_helper'

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

  def test_it_uses_tmp_dir
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
end
