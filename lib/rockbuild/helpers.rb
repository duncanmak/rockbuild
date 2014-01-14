module Rockbuild
  module Helpers
    def tar(*args)
      `tar #{args * ' '}`
    end
  end
end
