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

    def build(type, attributes = {})
      node = Nokogiri::XML::Node.new(type.to_s, document)
      node.attributes = attributes

      yield node if block_given?

      node
    end

    # Builds a bookmark with given attributes and add it.
    def add_bookmark(title, href, attributes = {}, &block)
      attributes = attributes.merge :title => title, :href => href
      add_child build(:bookmark, attributes, &block)
    end
    # Builds a folder with given attributes and add it.
    def add_folder(title, attributes = {}, &block)
      attributes = attributes.merge :title => title
      add_child build(:folder, attributes, &block)
    end
    # Builds an alias with given attributes and add it.
    def add_alias(ref)
      node = Nokogiri::XML::Node.new 'alias', document
      node.ref = (Entry === ref) ? ref.id : ref.to_s

      add_child node
    end
    # Builds a saperator with given attributes and add it.
    def add_separator
      add_child Nokogiri::XML::Node.new('separator', document)
    end

    def generate_id
      "#{ id }#{ document.div_id_er }" << xpath('./bookmark | ./folder').
          inject(0) { |next_id, child|
              succ_num_id = child.id[/(\d+)$/, 1].to_i.succ
              succ_num_id > next_id ? succ_num_id : next_id
          }.to_s
    end

    protected

      def add_child(node)
        if Entry === node
          node.id ||= generate_id
          node.added = Time.now
        end

        super
      end

  end
end
