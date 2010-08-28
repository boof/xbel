module Nokogiri::Decorators::XBEL
  module Separator

    @@title = ' '

    # Setter for Separator#to_s
    def self.title=(title)
      @@title = title.to_s
    end

    # Returns a single space.
    def to_s
      @@title
    end
    def separator? #:nodoc:
      true
    end

  end
end
