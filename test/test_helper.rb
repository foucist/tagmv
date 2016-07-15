require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tag_mv'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'

require 'pry'
