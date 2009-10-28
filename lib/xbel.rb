require 'forwardable'

require 'nokogiri'
require 'nokogiri/decorators/xbel'

require 'watchr'

class XBEL < Nokogiri::XML::Document
  extend Forwardable
  def_delegators :root, :title, :title=, :desc, :desc=

  autoload :Writer, 'xbel/writer'

  # Use <tt>XBEL.parse(string)</tt> create an instance.
  def initialize(*args)
    super
    decorators(Nokogiri::XML::Node) << Nokogiri::Decorators::XBEL
    decorate!

#    self.root = '<xbel version="1.0"></xbel>'
  end

  # Returns an array of version numbers.
  def version
    root.attribute('version').value.split('.').map { |n| n.to_i }
  end
  # Sets version numbers.
  def version=(*numbers)
    root.attribute('version').value = numbers.join '.'
  end

  # Writes XBEL to path.
  def write(path)
    # TODO: should start locking write process
    Writer.new(self, path).write
  end

end
