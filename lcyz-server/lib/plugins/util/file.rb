module Util
  class File
    def self.delete(path)
      ::File.unlink(path) if ::File.exist?(path)
    end
  end
end
