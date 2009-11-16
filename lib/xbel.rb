require 'forwardable'

require 'nokogiri'
require 'nokogiri/decorators/xbel'

class XBEL < Nokogiri::XML::Document
  extend Forwardable
  def_delegators :root,
      :title, :title=,
      :desc, :desc=,
      :id, :id=

  attr_accessor :div_id_er

  TEMPLATE = %Q'<!DOCTYPE xbel PUBLIC "+//IDN python.org//DTD XML Bookmark Exchange Language 1.0//EN//XML" "http://www.python.org/topics/xml/dtds/xbel-1.0.dtd"><xbel version="1.0" id="0"></xbel>'
  DIV_ID_ER = '_'

  # Returns an instance of XBEL.
  def self.new(attributes = {})
    xbel = parse TEMPLATE
    xbel.attributes = attributes

    xbel
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

    @div_id_er = DIV_ID_ER
  end

  # Returns node with given <tt>id</tt>.
  def [](id)
    root.at("//*[@id='#{ id }']")
  end

  def attributes=(attributes)
    version = attributes.delete(:version) and self.version = version
    div_id_er = attributes.delete(:div_id_er) and self.div_id_er = div_id_er

    root.attributes = attributes
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
