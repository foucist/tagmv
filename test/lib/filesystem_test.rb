require 'test_helper'

class FilesystemTest < Minitest::Test
  def before 
    @dir = Dir.mktmpdir
    TagMv::Filesystem.root = @dir
  end

  def after
    FileUtils.remove_entry @dir
  end

  def test_it_uses_root_for_target_dir
    dir = '/tmp/foobar'
    TagMv::Filesystem.root = dir
    tags = ['a','b']
    tfs = TagMv::Filesystem.new(tags: ['a','b'])
    assert tfs.target_dir == [dir, *tags].join('/')
  end

  def test_it_makes_tag_dirs
    before

    tags = ['a', 'b', 'c']
    tfs = TagMv::Filesystem.new(tags: tags)

    assert File.exist?(tfs.target_dir) == false
    tfs.prepare_dir
    assert File.exist?(tfs.target_dir) == true

    after
  end

  def test_it_moves_file_to_tag_dirs
    before
    tags = ['a', 'b', 'c']

    file = File.join(@dir, 'timestamp')
    assert FileUtils.touch(file)

    tfs = TagMv::Filesystem.new(tags: tags, files: file)
    tfs.transfer
    assert File.exist?(File.join(tfs.target_dir, 'timestamp'))

    after
  end

  def test_it_moves_directory_to_tag_dirs
    #FileUtils.mv Dir.glob('test*.rb'), 'test'
  end

  def test_it_moves_multiple_things_to_tag_dirs
  end
end
