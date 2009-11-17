module Nokogiri::Decorators::XBEL

  autoload :Bookmark, "#{ File.dirname __FILE__ }/xbel/bookmark.rb"
  autoload :Folder, "#{ File.dirname __FILE__ }/xbel/folder.rb"
  autoload :Alias, "#{ File.dirname __FILE__ }/xbel/alias.rb"
  autoload :Separator, "#{ File.dirname __FILE__ }/xbel/separator.rb"

  def self.extended(base)
    case base.name
    when 'title'
    when 'desc'
    when 'bookmark'
      base.extend Bookmark
    when 'folder'
      base.extend Folder
    when 'alias'
      base.extend Alias
    when 'separator'
      base.extend Separator
    when 'xbel'
      base.extend Folder
    end
  end

  module Entry

    def initialize_decorator
      @info = Hash.new do |info, owner|
        if String === owner
          info[owner] = at "./info/metadata[@owner='#{owner}']"
        else
          info[owner.to_s]
        end
      end
    end
    attr_reader :info

    def attributes=(attributes)
      attributes.each { |key, value| send "#{ key }=", value }
    end

    # Returns description of node.
    def desc
      if node = at('./desc') then node.content end
    end
    # Sets description of node.
    def desc=(value)
      node = at './desc'
      node ||= add_child Nokogiri::XML::Node.new('desc', document)

      node.content = value
    end
    alias_method :description, :desc
    alias_method :description=, :desc=

    # Returns title fo node.
    def title
      if node = at('./title') then node.content end
    end
    # Sets title for node.
    def title=(value)
      node = at './title'
      node ||= add_child Nokogiri::XML::Node.new('title', document)

      node.content = value
    end
    alias_method :to_s, :title

    # Returns id for node.
    def id
      if id = attribute('id') then id.content end
    end
    # Sets id for node.
    def id=(value)
      set_attribute 'id', value.to_s
    end

    # Returns addition date.
    def added
      if value = attribute('added') then Date.parse value.content end
    end
    # Sets addition date.
    def added=(value)
      set_attribute 'added', case value
      when Time; value.strftime '%Y-%m-%d'
      when String; value
      else
        raise ArgumentError
      end
    end
  end

  # Returns nil.
  def alias?; end
  # Returns nil.
  def bookmark?; end
  # Returns nil.
  def folder?; end

end
