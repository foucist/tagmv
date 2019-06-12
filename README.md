# Tagmv

The ultimate keep-your-files-organized solution!

Moves your files into directories that represent tags, these tags are kept organized as a hierarchy according to usage.

Tag all your files with multiple tags, and watch them end up organized!

Relies on convention-only, no FUSE, no symbolic links, no hard links.  No special tools required.

## Installation

    $ gem install tagmv

## Usage

    $ tagmv file1 file2 directory1 directory2 -t tag1 tag2 tag3

This will move your files and directories into:

    ~/t/tag1-/tag2-/tag3-/

As you tag more files and folders, it will re-order the tag directories by the most commonly used tags, keeping your files automatically organized for you.

## Current features

Default root directory for all your tagged files is `~/t/` (not configurable yet)

## Configuration

Configuration file: `~/.tagmv.yml`

Supports top level tags - so that you can "pin" certain tags to always show as the top level directories within `~/t/`

## Commands

`-d, --dry-run` Check to see what gets moved where

`-r, --reorder` **[default]** Move everything in `~/t/` into order of tag usage (example: `tagmv -r`)

`-s, --skip-reorder` Skip reorder (e.g. you are editing tagged files and don't want them moved around yet)

`-t, --tags *tags` Tags for your files or directories, as many as you want


## Upcoming features

Dealing with tags - remove specific tags, rename/merge similar tags, listing tags, etc.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/foucist/tagmv.

