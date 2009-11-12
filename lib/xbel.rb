require 'forwardable'

require 'nokogiri'
require 'nokogiri/decorators/xbel'

class XBEL < Nokogiri::XML::Document
  extend Forwardable
  def_delegators :root, :title, :title=, :desc, :desc=

  # Returns an instance of XBEL.
  def self.new(major = 1, minor = 0)
    parse %Q'<!DOCTYPE xbel PUBLIC "+//IDN python.org//DTD XML Bookmark Exchange Language 1.0//EN//XML" "http://www.python.org/topics/xml/dtds/xbel-1.0.dtd"><xbel version="%i.%i"></xbel>' % [major, minor]
  end

  # Reads file at <tt>path</tt> into <tt>parse</tt>.
  # @yield [XBEL]
  # @see Nokogiri.parse
  def self.open(path, &block)
    parse File.read(path.to_s), &block
  end

  # Calls <tt>Nokogiri#initialize</tt> and decorates XBEL nodes.
  def initialize(*args)
    super
    decorators(Nokogiri::XML::Node) << Nokogiri::Decorators::XBEL
    decorate!
  end

  # Returns node with given <tt>id</tt>.
  def [](id)
    root.at("//*[@id='#{ id }']")
  end

  # Returns an array of version numbers.
  def version
    root.attribute('version').value.split('.').map { |n| n.to_i }
  end
  # Sets version numbers.
  def version=(*numbers)
    root.attribute('version').value = numbers * '.'
  end

end
