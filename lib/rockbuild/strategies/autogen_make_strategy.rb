require 'rockbuild/strategies/configure_make_strategy'

include Rockbuild

module Rockbuild
  class AutogenMakeStrategy < ConfigureMakeStrategy
    private

    def configure_command(package)
      "./autogen.sh --prefix=#{Env.prefix} #{merge_flags(package.configure_flags)}"
    end
  end
end
