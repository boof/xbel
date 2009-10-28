require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'xbel'

class Test::Unit::TestCase
  include Nokogiri::Decorators::XBEL
  attr_reader :xbel
end
