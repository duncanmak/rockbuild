module Rockbuild
  module Commands
    def configure(*args)
      _run("./configure", args)
    end

    def autogen_sh(*args)
      _run("./autogen.sh", args)
    end

    def make(*args)
      _run("make", args)
    end

    def lipo(*args)
      _run("lipo", args)
    end

    def patch(*args)
      _run('patch', args)
    end

    def chdir(dir,&block)
      dry_run("cd", [dir])

      if Env.dry_run?
        block.call
      else
        Dir.chdir(dir) { block.call }
      end
    end

    def mkdir_p(dir)
      dry_run("mkdir_p", [dir])
      FileUtils.mkdir_p (dir) unless Env.dry_run?
    end

    def delete(file)
      dry_run("delete", [file])
      File.delete (file) unless Env.dry_run?
    end

    def touch(file)
      dry_run("touch", [file])
      File.open(build_success_file, 'w') unless Env.dry_run?
    end

    def download_file(file, url)
      dry_run("download", [file, url])
      unless Env.dry_run?
        File.open(file, "wb") do |output|
          open(url) { |input| output.write(input.read) }
        end
      end
    end

    private

    def profile(name)
      prefix = File.join(Env.root, 'build-root', name.to_s, '_install')

      {
        cflags:  [ "-I#{prefix}/include" ],
        ldflags: [ "-L#{prefix}/lib" ],
        path:    [ ENV['PATH'], "#{prefix}/bin", '/usr/bin', '/bin' ]
      }
    end

    def default_env
      profile = profile(Env.profile)
      library_path = if Env.host =~ /linux/
        { 'LD_LIBRARY_PATH' => "#{Env.prefix}/lib" }
      elsif Env.host =~ /mac/
        { 'DYLD_LIBRARY_PATH' => "#{Env.prefix}/lib" }
      else
        {}
      end

      library_path.merge({
        'PATH'            => merge_flags(profile[:path], ':'),
        'CFLAGS'          => merge_flags(profile[:cflags]),
        'CPPFLAGS'        => merge_flags(profile[:cflags]),
        'CXXFLAGS'        => merge_flags(profile[:cflags]),
        'LDFLAGS'         => merge_flags(profile[:ldflags]),
        'PKG_CONFIG_PATH' => "#{Env.prefix}/lib/pkgconfig"
      })
    end

    def merge_flags(flags_array, separator = ' ')
      flags_array.join(separator)
    end

    def _run(cmd, args)
      if Env.dry_run?
        dry_run(cmd, args)
      else
        really_run(cmd, args)
      end
    end

    def dry_run(cmd, args)
      command = "\"#{cmd}\" #{args * ' '}"
      now = Time.new.strftime("%H:%M:%S")
      puts "#{now} - Running #{command} in #{Dir.pwd}" unless Env.quiet?
    end

    def really_run(cmd, args)
      dry_run(cmd, args)
      command = "\"#{cmd}\" #{args * ' '}"
      IO.popen(default_env, command) do |io|
        until io.eof?
          output = io.gets
          puts output unless Env.quiet?
        end
        io.close
        raise "#{command} failed" if ($?.to_i != 0)
      end
    end
  end
end
