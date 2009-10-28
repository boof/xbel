module Nokogiri::Decorators::XBEL
  module Alias
    extend Forwardable
    def_delegators :entry,
        :description, :title, :to_s, :id, :added, :bookmark?, :folder?

    def ref
      attribute('ref').content
    end
    def ref=(value)
      set_attribute 'ref', value.to_s
    end
    alias_method :reference, :ref
    alias_method :reference=, :ref=

    def entry
      at %Q'//*[@id="#{ ref }"]'
    end

    def alias?
      true
    end

  end
end
