require 'forwardable'

require 'nokogiri'
require 'nokogiri/decorators/xbel'

class XBEL < Nokogiri::XML::Document
  extend Forwardable
  def_delegators :root, :title, :title=, :desc, :desc=

  def self.new(major = 1, minor = 0)
    parse %Q'<!DOCTYPE xbel PUBLIC "+//IDN python.org//DTD XML Bookmark Exchange Language 1.0//EN//XML" "http://www.python.org/topics/xml/dtds/xbel-1.0.dtd"><xbel version="%i.%i"></xbel>' % [major, minor]
  end

  def self.open(path)
    parse File.read(path.to_s)
  end

  # Use <tt>XBEL.parse(string)</tt> create an instance.
  def initialize(*args)
    super
    decorators(Nokogiri::XML::Node) << Nokogiri::Decorators::XBEL
    decorate!
  end

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
