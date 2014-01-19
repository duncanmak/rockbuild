module Rockbuild
  PROFILE = {
    mac32: {
      cflags: [ '-I$prefix/include' ],
      ldflags: [ '-L$prefix/lib' ]
    }
  }
end
