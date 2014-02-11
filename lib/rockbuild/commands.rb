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

    private

    def _run(cmd, args)
      if RockbuildCLI.dry_run?
        dry_run(cmd, args)
      else
        really_run(cmd, args)
      end
    end

    def dry_run(cmd, args)
      command = "\"#{cmd}\" #{args * ' '}"
      now = Time.new.strftime("%H:%M:%S")
      puts "#{now} - Running #{command} in #{Dir.pwd}"
    end

    def really_run(cmd, args)
      dry_run(cmd, args)
      command = "\"#{cmd}\" #{args * ' '}"
      IO.popen(default_env, command) do |io|
        until io.eof?
          output = io.gets
          puts output unless RockbuildCLI.quiet?
        end
        io.close
        raise "#{command} failed" if ($?.to_i != 0)
      end
    end
  end
end
