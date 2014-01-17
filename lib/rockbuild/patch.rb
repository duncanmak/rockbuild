module Rockbuild
  class Patch
    attr_reader :path
    attr_reader :patchlevel

    def initialize(full_path, patchlevel = 0)
      @path = full_path
      @patchlevel = patchlevel
    end

    def apply
    end
  end
end
