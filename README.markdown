# xbel

Introduces XBEL decorations for Nokogiri.

## Installation

    gem install xbel

## Using

    require 'rubygems'
    require 'xbel'

### Reading

    XBEL.open('test/wikipedia.xbel')[:f0].bookmarks.
    map do |bookmark|
      link_to bookmark.title, bookmark.href
    end

### Writing

    xbel = XBEL.new
    xbel.build_folder 'XBEL' do |folder|
      folder.build_bookmark "boof's xbel", 'http://github.com/boof/xbel'
    end
    File.open('my.xbel', 'w') { |file| file << xbel }

_Note: You can use all Nokogiri::XML::Node methods._

## Patches/Pull Requests:
 
1. Fork the project.
2. Make your feature addition or bug fix.
3. Add tests for it. This is important so I don't break it in a
   future version unintentionally.
4. Commit, do not mess with rakefile, version, or history.
5. Send me a pull request.

### Copyright

Copyright (c) 2009 Florian Aßmann. See LICENSE for details.
