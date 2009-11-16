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

    def build(type, attributes = {}, &block)
      child = Nokogiri::XML::Node.new(type.to_s, document)
      assign_to child, attributes, &block

      add_child child
    end

    # Builds a bookmark with given attributes and add it.
    def build_bookmark(title, href, attributes = {}, &block)
      build :bookmark,
          attributes.merge(:title => title, :href => href),
          &block
    end
    # Builds a folder with given attributes and add it.
    def build_folder(title, attributes = {}, &block)
      build :folder,
          attributes.merge(:title => title),
          &block
    end
    # Builds an alias with given attributes and add it.
    def build_alias(ref)
      child = Nokogiri::XML::Node.new('alias', document)
      child.ref = (Entry === ref) ? ref.id : ref.to_s

      add_child child
    end
    # Builds a saperator with given attributes and add it.
    def add_separator
      add_child Nokogiri::XML::Node.new('separator', document)
    end

    protected

      def assign_to(node, attributes) #:nodoc:
        attributes[:id] ||= "#{ id }." << xpath('./bookmark | ./folder').
            inject(0) { |next_id, child|
                succ_num_id = child.id[/(\d+)$/, 1].to_i.succ
                succ_num_id > next_id ? succ_num_id : next_id
            }.to_s

        attributes.each do |key, value|
          node.send "#{ key }=", value
        end

        yield node if block_given?
      end

  end
end
