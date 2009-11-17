require 'helper'

context 'XBEL' do
  setup { XBEL }

  context 'build with defaults' do
    setup { topic.new }

    asserts 'version' do
      topic.version
    end.equals [1, 0]
    asserts 'version set' do
      topic.version = 1, 1
      topic.version
    end.equals [1, 1]
    should 'be empty' do
      topic.root.content.empty?
    end
    should 'have an id divider' do
      String === topic.div_id_er and
      topic.div_id_er.length > 0
    end
  end
  context 'built with attributes' do
    setup { topic.new :version => [2, 2], :div_id_er => '/', :id => 'custom' }

    asserts 'user defined version' do
      topic.version
    end.equals [2, 2]
    asserts 'div_id_er' do
      topic.div_id_er
    end.equals '/'
    asserts 'id' do
      topic.id
    end.equals 'custom'

    asserts 'id of added folder' do
      topic.root.add_folder('foo').id
    end.equals 'custom/0'
  end

  context 'loaded from wikipedia.xbel' do
    setup do
      root = Pathname.new File.dirname(__FILE__)
      topic.open root.join('wikipedia.xbel')
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

    context 'root' do
      setup { topic.root }
      context 'new Bookmark' do
        setup do
          topic.add_bookmark "boof's xbel", 'http://www.github.com/boof/xbel',
              :description => 'Ruby API for XBEL based on Nokogiri.'
        end
        asserts('next id') { topic.id }.equals 'test_2'
      end
    end

    context 'Folder' do
      setup { topic[:test_1] }
      should('be a folder') { topic.folder? }

      asserts('title') { topic.title }.equals 'Wiki'
      asserts('entries names') do
        topic.entries.map { |e| e.name }.uniq.sort
      end.equals %w[ alias bookmark folder separator ]
      should('return bookmarks') do
        not topic.bookmarks.any? { |b| b.name != 'bookmark' }
      end
      should('return aliases') do
        not topic.aliases.any? { |b| b.name != 'alias' }
      end
      should('return folders') do
        not topic.folders.any? { |b| b.name != 'folder' }
      end

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
          topic.add_bookmark "boof's xbel", 'http://www.github.com/boof/xbel',
              :description => 'Ruby API for XBEL based on Nokogiri.'
        end
        should('be a bookmark') { topic.bookmark? }

        asserts('added') { topic.added }.equals Date.today
        asserts('title') { topic.title }.equals 'boof\'s xbel'
        asserts('next id') { topic.id }.equals 'test_1_4'
        asserts('href') { topic.href }.
            equals 'http://www.github.com/boof/xbel'
        asserts('description') { topic.description }.
            equals 'Ruby API for XBEL based on Nokogiri.'
      end

      context 'new Folder' do
        setup { topic.add_folder 'sub', :desc => 'desc' }
        should('be a folder') { topic.folder? }

        asserts('added') { topic.added }.equals Date.today
        asserts('title') { topic.title }.equals 'sub'
        asserts('next id') { topic.id }.equals 'test_1_4'
        asserts('desc') { topic.desc }.equals 'desc'
      end

      context 'new Alias' do
        setup { topic.add_alias topic }
        should('be an alias') { topic.alias? }

        should('reference its folder') { topic.entry == topic.parent }
        should('set reference by entry') do
          topic.entry = topic.document[:test_1_3]
          topic.ref == 'test_1_3'
        end
      end

      context 'Separator' do
        setup { topic.entries.find { |e| e.name == 'separator' } }
        asserts('to_s') { topic.to_s }.equals ' '
        should('not be a bookmark') { !topic.bookmark? }
        should('not be a alias') { !topic.alias? }
        should('not be a folder') { !topic.folder? }
      end

    end

    context 'Bookmark test_1_1' do
      setup { topic[:test_1_1] }
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

end
