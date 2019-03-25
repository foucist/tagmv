# Tagmv

The ultimate keep-your-files-organized solution!

Moves your files into directories that represent tags, these tags are kept organized as a hierarchy according to tag counts.

Tag all your files with multiple tags, and watch them end up organized!

Works using the most basic parts of the filesystem - no FUSE, no symbolic or hard links.

## Installation

    $ gem install tagmv

## Usage

    $ tagmv file1 file2 directory1 directory2 -t tag1 tag2 tag3

This will move your files and directories into:

    ~/t/tag1-/tag2-/tag3-/

As you tag more files and folders, it will order the tag directories according to the most popular tags, keeping things organized for you.

## Current features

Default directory is "~/t/" (not configurable yet, oops)

Supports top level tags - so that you can "pin" certain tags to be the top level directory

Config file: ~/.tagmv.yml   currently supports the top level tags (no easy way to update config yet)


## Upcoming features

Dealing with tags - remove specific tags, rename/merge similar tags, listing tags, etc.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/foucist/tagmv.

