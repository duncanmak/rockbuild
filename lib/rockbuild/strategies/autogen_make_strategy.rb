require 'rockbuild/strategies/configure_make_strategy'

include Rockbuild

module Rockbuild
  class AutogenMakeStrategy < ConfigureMakeStrategy
    private

    def configure_command
      autogen_sh
    end
  end
end
