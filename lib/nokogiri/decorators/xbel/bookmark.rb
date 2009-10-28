module Nokogiri::Decorators::XBEL
  module Bookmark
    include Entry

    def modified
      if value = attribute('modified') then Date.parse value.content end
    end
    def modified=(value)
      set_attribute 'modified', value.to_s
    end
    def visited
      if value = attribute('visited') then Date.parse value.content end
    end
    def visited=(value)
      set_attribute 'visited', value.to_s
    end
    def visit
      self.visited = Date.today
    end
    def href
      if value = attribute('href') then value.content end
    end
    def href=(value)
      self.modified = Date.today
      set_attribute 'href', value
    end
    def bookmark?
      true
    end

  end
end
