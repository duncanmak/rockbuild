require 'rockbuild/profile'

class DemoProfile < Profile
  def packages
    [
      Autoconf,
      Automake
    ]
  end
end
