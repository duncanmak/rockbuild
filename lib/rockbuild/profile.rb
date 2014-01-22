module Rockbuild
  PROFILE = {
    mac32: {
      cflags: [ "-I#{Env.prefix}/include" ],
      ldflags: [ "-L#{Env.prefix}/lib" ],
      path: [ ENV['PATH'], "#{Env.prefix}/bin", '/usr/bin', '/bin' ]
    }
  }
end
