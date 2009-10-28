class XBEL::Writer #:nodoc:
  DOCTYPE = '<!DOCTYPE xbel PUBLIC "+//IDN python.org//DTD XML Bookmark Exchange Language 1.0//EN//XML" "http://www.python.org/topics/xml/dtds/xbel-1.0.dtd">'

  attr_reader :document, :lockfile_path, :path
  def new(document, path)
    @document, @path = document, path
    @lockfile_path = "#{ path }.lock"
  end

  def write
    synchronize do
      File.open path, 'w' do |file|
        file.puts DOCTYPE
        file << document
      end
    end
  end

  protected

    def locked?(path)
      File.exists? lockfile_path
    end
    def lock
      File.open(lockfile_path, 'w') { |*| yield }
    ensure
      File.unlink lockfile_path
    end

    def synchronize
      current_thread = Thread.current

      while locked?
        watch(lockfile_path, :delete) { |*| current_thread.run }
        current_thread.sleep
      end

      lock { yield }
    end

end
