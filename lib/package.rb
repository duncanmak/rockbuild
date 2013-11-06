require 'open-uri'

class Package

  # Subclasses must implement these accessors
  # attr_reader :name, :version, :sources

  def build_success_file
    File.join(@root_directory, "#{self}.success")
  end

  def phases() [:download, :prep, :build, :install] end

  def is_successful_build?
    def newer_than_sources?
      mtime = File.mtime(build_success_file)
      not @sources.select { |s| File.file?(s) && File.mtime(s) > mtime }.empty?
    end

    File.exists?(build_success_file) && newer_than_sources?
  end

  def start(root_directory)
    if is_successful_build?()
      log "Skipping #{self} - already build"
      install
    end

    @root_directory = root_directory

    phases.each do |phase| (send phase) end
  end

  def working_directory
    File.join(@root_directory, to_s)
  end

  def to_s() "#{name}-#{version}" end

  def download
    @sources.each do |s|
      s.download!(@root_directory)
    end
  end

  def prep
    puts "Package#prep"
  end

  def build
    puts "Package#build"
  end

  def install
    puts "Package#install"
  end
end
