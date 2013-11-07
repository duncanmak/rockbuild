module Helpers

  def unzip(file) `unzip -o #{file}` end
  def untar(file) `#{tar} xf #{file}` end

end
