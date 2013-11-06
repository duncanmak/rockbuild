require_relative 'lib/helpers'
require_relative 'lib/package'
require_relative 'lib/profile'
require_relative 'lib/sources'

# Require all the packages
cwd = File.expand_path('../', __FILE__)
Dir["#{cwd}/packages/**/*.rb"].each do |pkg| require pkg end
