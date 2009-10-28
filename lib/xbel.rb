require 'forwardable'

require 'nokogiri'
require 'nokogiri/decorators/xbel'

require 'watchr'

class XBEL < Nokogiri::XML::Document
  extend Forwardable
  def_delegators :root, :title, :title=, :desc, :desc=

  autoload :Writer, 'xbel/writer'

  def initialize(*args)
    super
    decorators(Nokogiri::XML::Node) << Nokogiri::Decorators::XBEL
    decorate!

#    self.root = '<xbel version="1.0"></xbel>'
  end

  def version
    root.attribute('version').value.split('.').map { |n| n.to_i }
  end
  def version=(*numbers)
    root.attribute('version').value = numbers.join '.'
  end

  def write(path)
    Writer.new(self, path).write
  end

end
