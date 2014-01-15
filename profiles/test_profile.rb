require 'rockbuild/profile'

class TestProfile < Profile
  def packages
    [
      Autoconf,
      Automake
    ]
  end
end
