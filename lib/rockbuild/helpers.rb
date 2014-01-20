module Rockbuild
  module Helpers
    # This is a helper for locating commonly installed binary dependencies such
    # as git or tar. We could be smarter for *nixy systems and actually check
    # if it's installed, but the reality is that our users probably know how to
    # install this stuff on those platforms but maybe not on Windows.
    def common_bin_path(exe_name)
      if Env.host == :windows
        exe_path = [
          "C:\\Program Files\\Git\\bin\\#{exe_name}.exe",
          "C:\\Program Files (x86)\\Git\\bin\\#{exe_name}.exe",
          "C:\\msys\\1.0\\bin\\#{exe_name}.exe"
        ].find { |filename| File.exists?(filename) }

        raise "You must install git."

        exe_path
      else
        exe_name
      end
    end
  end
end
