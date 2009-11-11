module Nokogiri::Decorators::XBEL
  module Folder
    include Entry

    def self.extended(node)
      node.initialize_decorator
    end

    # Returns an instance of NodeSet with possible children in this folder.
    def entries
      xpath './alias | ./bookmark | ./folder | ./separator'
    end
    # Returns an instance of NodeSet with all aliases in this folder.
    def aliases
      xpath './alias'
    end
    # Returns an instance of NodeSet with all bookmarks in this folder.
    def bookmarks
      xpath './bookmark'
    end
    # Returns an instance of NodeSet with all folders in this folder.
    def folders
      xpath './folder'
    end

    # Returns true.
    def folder?
      true
    end

    # Adds a entry and sets added attribute.
    def add_child(node)
      node.added = Date.today if node.is_a? Entry
      super
    end

    # Builds a bookmark with given attributes and add it.
    def build_bookmark(title, href, attributes = {}, &block)
      node = Nokogiri::XML::Node.new('bookmark', document)
      assign_to node, attributes.merge('title' => title, 'href' => href),
          &block

      add_child node
    end
    # Builds a folder with given attributes and add it.
    def build_folder(title, attributes = {}, &block)
      node = Nokogiri::XML::Node.new('folder', document)
      assign_to node, attributes.merge('title' => title), &block

      add_child node
    end
    # Builds an alias with given attributes and add it.
    def build_alias(ref)
      node = Nokogiri::XML::Node.new('alias', document)
      node.ref = (Entry === ref) ? ref.id : ref.to_s

      add_child node
    end
    # Builds a saperator with given attributes and add it.
    def add_separator
      add_child Nokogiri::XML::Node.new('separator', document)
    end

    protected

      def assign_to(node, attributes) #:nodoc:
        attributes.each do |key, value|
          node.send "#{ key }=", value
        end
        yield node if block_given?
      end

  end
end
