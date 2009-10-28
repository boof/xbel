module Nokogiri::Decorators::XBEL
  module Folder
    include Entry

    def entries
      xpath './alias', './bookmark', './folder', './separator'
    end
    def aliases
      xpath './alias'
    end
    def bookmarks
      xpath './bookmark'
    end
    def folders
      xpath './folder'
    end

    def folder?
      true
    end

    def add_child(node)
      node.added = Date.today if node.is_a? Entry
      super
    end

    def build_bookmark(attributes = {}, &block)
      node = Nokogiri::XML::Node.new('bookmark', document)
      assign_to node, attributes

      add_child node
    end
    def build_folder(attributes = {}, &block)
      node = Nokogiri::XML::Node.new('folder', document)
      assign_to node, attributes

      add_child node
    end
    def build_alias(ref)
      node = Nokogiri::XML::Node.new('alias', document)
      node.ref = (Entry === ref) ? ref.id : ref.to_s

      add_child node
    end
    def add_seperator
      add_child Nokogiri::XML::Node.new('separator', document)
    end

    protected

      def assign_to(node, attributes)
        attributes.each do |key, value|
          node.send "#{ key }=", value
        end
        yield node if block_given?
      end

  end
end
