module Nokogiri::Decorators::XBEL
  module Alias
    extend Forwardable
    def_delegators :entry,
        :description, :title, :to_s, :id, :added, :bookmark?, :folder?

    # Returns reference to bookmark or folder id.
    def ref
      attribute('ref').content
    end
    # Sets reference of bookmark or folder id.
    def ref=(bookmark_or_folder_id)
      set_attribute 'ref', bookmark_or_folder_id.to_s
    end
    alias_method :reference, :ref
    alias_method :reference=, :ref=

    # Returns referenced bookmark or folder.
    def entry
      at %Q'//*[@id="#{ ref }"]'
    end
    # Sets referenced bookmark or folder.
    def entry=(bookmark_or_folder)
      self.ref = bookmark_or_folder.id
    end

    # Returns true.
    def alias?
      true
    end

  end
end
