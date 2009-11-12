module Nokogiri::Decorators::XBEL
  module Bookmark
    include Entry

    def self.extended(node)
      node.initialize_decorator
    end

    # Returns modification date.
    def modified
      if value = self['modified'] then Date.parse value end
    end
    # Sets modification date.
    def modified=(value)
      self['modified'] = value.to_s
    end
    # Returns visit date.
    def visited
      if value = self['visited'] then Date.parse value end
    end
    # Sets visit date.
    def visited=(value)
      self['visited'] = value.to_s
    end
    # Sets visit to today.
    def visit
      self.visited = Date.today
    end
    # Returns href value.
    def href
      if value = self['href'] then value end
    end
    # Sets href value.
    def href=(value)
      self.modified = Date.today
      self['href'] = value
    end
    # Returns true.
    def bookmark?
      true
    end

  end
end
