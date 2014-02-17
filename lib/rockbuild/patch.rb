module Rockbuild
  class Patch
    include Commands

    attr_reader :path
    attr_reader :patchlevel

    def initialize(filename, patchlevel = 0)
      @filename = filename
      @patchlevel = patchlevel
    end

    def apply
      patch("-p#{@patchlevel}", "<", full_path)
    end

    def full_path
      @@path ||= File.join(Env.root, 'patches', @filename)
    end
  end
end
