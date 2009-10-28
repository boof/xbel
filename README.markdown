# xbel

Introduces XBEL decorations for Nokogiri. Write support is still in
development.

## Installation

    gem install xbel

## Use

    require 'rubygems'
    require 'xbel'

    xbel = XBEL.parse File.read('complex.xbel')

    with_aliases = true # TODO...
    xbel.root.bookmarks(with_aliases).each { |bm| system 'open', bm.href }

### Note on Patches/Pull Requests
 
1. Fork the project.
2. Make your feature addition or bug fix.
3. Add tests for it. This is important so I don't break it in a
   future version unintentionally.
4. Commit, do not mess with rakefile, version, or history.
5. Send me a pull request.

### Copyright

Copyright (c) 2009 Florian Aßmann. See LICENSE for details.
