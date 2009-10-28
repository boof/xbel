require 'helper'

class TestXBEL < Test::Unit::TestCase
  context 'Read XBEL' do
    setup do
      @path = Pathname.new("#{ File.dirname __FILE__ }").join "complex.xbel"
      @xbel = XBEL.parse @path.read
    end
    should "have version [1, 0]" do
      assert_equal [1, 0], xbel.version
    end
    should "have title 'Some of David's Bookmarks'" do
      assert_equal %Q{Some of David's Bookmarks}, xbel.title
    end
    should "return all root folders" do
      results = xbel.root.folders
      results = results.map { |folder| folder.title }
      expect = ['HTTP Clients', 'Extensible Markup Language (XML)']
      assert_equal expect, results
    end
    should "return all bookmarks of 'HTTP Clients'" do
      results = xbel.root.folders.first.bookmarks
      results = results.map { |entry| entry.title }
      expect = [
          'Netscape', 'Opera', 'Microsoft Internet Explorer', 'Lynx', 'Amaya'
      ]
      assert_equal expect, results
    end
    should "return aliased bookmark" do
      result = xbel.root.folders.first.aliases.first.entry
      expect = xbel.root.folders.first.bookmarks.last
      assert_equal expect, result
    end
  end
end
