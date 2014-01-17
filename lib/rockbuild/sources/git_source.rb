include Rockbuild

class GitSource < Source
  private

  def extract!(cached_filename)
    puts "git extract! #{cached_filename} ************"
  end
end
