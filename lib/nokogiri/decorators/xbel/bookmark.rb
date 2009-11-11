module Nokogiri::Decorators::XBEL
  module Bookmark
    include Entry

    def self.extended(node)
      node.initialize_decorator
    end

    def modified
      if value = self['modified'] then Date.parse value end
    end
    def modified=(value)
      self['modified'] = value.to_s
    end
    def visited
      if value = self['visited'] then Date.parse value end
    end
    def visited=(value)
      self['visited'] = value.to_s
    end
    def visit
      self.visited = Date.today
    end
    def href
      if value = self['href'] then value end
    end
    def href=(value)
      self.modified = Date.today
      self['href'] = value
    end
    def bookmark?
      true
    end

  end
end
