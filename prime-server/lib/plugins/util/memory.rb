module Util
  class Memory
    def self.current
      GetProcessMem.new.mb
    end
  end
end
