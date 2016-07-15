# TagMv

File tagging by moving files into tag-based directories.

The directories that represent tags are organized hierarchically (either by # of items that have the tag or some other method).

- Organizes using the plain file system
- Extremely flexible (no tag limit, no tag naming restrictions, hierarchical tags, no file naming restrictions, can tag all files and directories).
- Transparent to other applications, since it works directly with the file system.

## Installation

    $ gem install tag_mv

## Usage

    $ tag <files/directories> -t <tags>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/foucist/tag_mv.

