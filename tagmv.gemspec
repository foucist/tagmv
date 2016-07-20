# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tag_mv/version'

Gem::Specification.new do |spec|
  spec.name          = "tagmv"
  spec.version       = TagMv::VERSION
  spec.authors       = ["James Robey"]
  spec.email         = ["james.robey+tagmv@gmail.com"]
  spec.summary       = %q{Tag your files by moving them into a tree-like tag structure}
  spec.description   = %q{Moves your files into directories that represent tags, these tags are kept organized as a hierarchy according to tag counts}
  spec.homepage      = "http://jamesrobey.com/tagmv/" #"https://github.com/foucist/tagmv/"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #spec.bindir        = "exe"
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)

  spec.add_development_dependency "bundler",  "~> 1.11"
  spec.add_development_dependency "rake",     "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "simplecov"

  spec.add_dependency 'choice', '0.2.0'


  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end
end
