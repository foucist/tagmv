require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tagmv'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'

require 'pry'
