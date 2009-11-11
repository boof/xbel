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
    root = Pathname.new File.dirname(__FILE__)
    XBEL.open root.join('wikipedia.xbel')
  end

  asserts('version') { topic.version }.equals [1, 0]

  asserts('title') { topic.title }.equals 'Lesezeichen!'
  should('delegate title accessor to root') do
    topic.title = 'Bookmarks!'

    topic.title == topic.root.title and
    topic.title == 'Bookmarks!'
  end

  context 'Alias' do
    setup { topic.root.aliases.first }
    should('be an alias') { topic.alias? }

    should('have a reference') do
      topic.ref and
      topic.ref == topic.reference
    end
  end

  context 'Folder' do
    setup { topic[:f0] }
    should('be a folder') { topic.folder? }

    asserts('title') { topic.title }.equals 'Wiki'
    # TODO: check type with <name>?
    asserts('entries') { topic.entries }.kind_of Nokogiri::XML::NodeSet
    asserts('bookmarks') { topic.bookmarks }.kind_of Nokogiri::XML::NodeSet
    asserts('aliases') { topic.aliases }.kind_of Nokogiri::XML::NodeSet
    asserts('folders') { topic.folders }.kind_of Nokogiri::XML::NodeSet

    context 'Bookmark' do
      setup { topic.bookmarks.first }
      should('be a bookmark') { topic.bookmark? }

      asserts('modified') { topic.modified }.kind_of Date

      asserts('visited') { topic.visited }.kind_of Date
      asserts('visit') do
        topic.visit
        topic.visited
      end.equals Date.today
    end
    context 'new Bookmark' do
      setup do
        topic.build_bookmark "boof's xbel", 'http://www.github.com/boof/xbel',
            :description => 'Ruby API for XBEL based on Nokogiri.'
      end
      should('be a bookmark') { topic.bookmark? }

      asserts('added') { topic.added }.equals Date.today
      asserts('title') { topic.title }.equals 'boof\'s xbel'
      asserts('href') { topic.href }.
          equals 'http://www.github.com/boof/xbel'
      asserts('description') { topic.description }.
          equals 'Ruby API for XBEL based on Nokogiri.'
    end

    context 'new Folder' do
      setup { topic.build_folder 'sub', :id => 'id-2', :desc => 'desc' }
      should('be a folder') { topic.folder? }

      asserts('added') { topic.added }.equals Date.today
      asserts('title') { topic.title }.equals 'sub'
      asserts('id') { topic.id }.equals 'id-2'
      asserts('desc') { topic.desc }.equals 'desc'
    end

    context 'new Alias' do
      setup { topic.build_alias topic }
      should('be an alias') { topic.alias? }

      should('reference its folder') { topic.entry == topic.parent }
    end

  end

  context 'Bookmark b0' do
    setup { topic[:b0] }
    should('be a bookmark') { topic.bookmark? }
    
    context 'Info' do
      setup { topic.info }
      should('be a hash') { Hash === topic }

      context 'metadata for xbel' do
        setup { topic[:xbel] if topic }
        should('be a node') { Nokogiri::XML::Node === topic }

        should('be have an alias') { not topic.at('./alias').nil? }
      end
    end

  end

end
