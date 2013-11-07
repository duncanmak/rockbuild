cwd = File.expand_path('../', __FILE__)

# Require rockbuild
Dir["#{cwd}/lib/**/*.rb"].each do |pkg| require pkg end

# Require all the packages
Dir["#{cwd}/packages/**/*.rb"].each do |pkg| require pkg end

$stdout.sync = true

load 'profiles/test_profile.rb'
