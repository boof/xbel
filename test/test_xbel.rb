require 'helper'

context 'New XBEL' do

  asserts 'version' do
    XBEL.new.version
  end.equals [1, 0]
  asserts 'user defined version' do
    XBEL.new(2, 2).version
  end.equals [2, 2]
  asserts 'set version' do
    xbel = XBEL.new
    xbel.version = 1, 1

    xbel.version
  end.equals [1, 1]
  should 'be empty' do
    XBEL.new.root.content.empty?
  end

end

context 'XBEL' do

  setup do
    path = File.join "#{ File.dirname __FILE__ }", 'wikipedia.xbel'
    @xbel = XBEL.parse File.read(path)
  end

  asserts('version') { @xbel.version }.equals [1, 0]

  asserts("title") { @xbel.title }.equals %q"Lesezeichen!"
  should('delegate title to root') { @xbel.root.title == @xbel.title }

  context 'Alias' do
    setup { @alias = @xbel.root.aliases.first }
    should('be an alias') { @alias.alias? }
  end

  context 'Folder' do
    setup { @folder = @xbel.root.folders.first }

    asserts('title') { @folder.title }.equals 'Wiki'
    asserts('entries') { @folder.entries }.kind_of Nokogiri::XML::NodeSet
    asserts('bookmarks') { @folder.bookmarks }.kind_of Nokogiri::XML::NodeSet
    asserts('aliases') { @folder.bookmarks }.kind_of Nokogiri::XML::NodeSet
    should('be a folder') { @folder.folder? }

    context 'Bookmark' do
      setup { @bookmark = @folder.bookmarks.first }

      asserts('modified attribute') { @bookmark.modified }.kind_of Date
      asserts('visited') { @bookmark.visited }.kind_of Date
      asserts('visit') { @bookmark.visit; @bookmark.visited }.equals Date.today
      should('be a bookmark') { @bookmark.bookmark? }
    end
    context 'new Bookmark' do
      setup do
        @bookmark = @folder.build_bookmark 'Bookmark',
            :href => 'http://www.github.com/boof/xbel', :description => 'desc'
      end

      asserts('added attribute') { @bookmark.added }.equals Date.today
      asserts('title attribute') { @bookmark.title }.equals 'Bookmark'
      asserts('href attribute') { @bookmark.href }.
          equals 'http://www.github.com/boof/xbel'
      asserts('description attribute') { @bookmark.description }.
          equals 'desc'
    end

    context 'new Folder' do
      setup do
        @subfolder = @folder.build_folder 'subfolder',
            :id => 'id-2', :desc => 'description'
      end
      asserts('added attribute') { @subfolder.added }.equals Date.today
      asserts('title attribute') { @subfolder.title }.equals 'subfolder'
      asserts('id attribute') { @subfolder.id }.equals 'id-2'
      asserts('desc attribute') { @subfolder.desc }.equals 'description'
    end

    context 'new Alias' do
      setup { @alias = @folder.build_alias @folder }
      should('reference its folder') { @alias.entry == @folder }
    end

  end

end
