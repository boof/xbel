module Nokogiri::Decorators::XBEL

  autoload :Folder, "#{ File.dirname __FILE__ }/xbel/folder.rb"
  autoload :Seperator, "#{ File.dirname __FILE__ }/xbel/folder.rb"
  autoload :Bookmark, "#{ File.dirname __FILE__ }/xbel/bookmark.rb"
  autoload :Alias, "#{ File.dirname __FILE__ }/xbel/alias.rb"

  def self.extended(base)
    case base.name
    when 'title'
    when 'desc'
    when 'bookmark'
      base.extend Bookmark
    when 'folder'
      base.extend Folder
    when 'separator'
      base.extend Separator
    when 'alias'
      base.extend Alias
    when 'xbel'
      base.extend Folder
    end
  end

  module Entry
    def desc
      if node = at('./desc') then node.content end
    end
    def desc=(value)
      node = at './desc'
      node ||= add_child Nokogiri::XML::Node.new('desc', document)

      node.content = value
    end
    alias_method :description, :desc
    alias_method :description=, :desc=

    def title
      if node = at('./title') then node.content end
    end
    def title=(value)
      node = at './title'
      node ||= add_child Nokogiri::XML::Node.new('title', document)

      node.content = value
    end
    alias_method :to_s, :title

    def id
      if id = attribute('id') then id.content end
    end
    def id=(value)
      set_attribute 'id', value.to_s
    end

    def added
      if value = attribute('added') then Date.parse value.content end
    end
    def added=(value)
      set_attribute 'added', value.to_s
    end

    def alias?; end
    def bookmark?; end
    def folder?; end
  end

end
