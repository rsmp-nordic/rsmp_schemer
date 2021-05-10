# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

namespace :schema do
	# task for adding scheme. run this like:
	# type=core version=3.1.3 rake schema:add

  task :add do
    type = ENV['type']
    version = ENV['version']
    raise ArgumentError.new("type argument is missing") unless /\w+/ =~ type
    raise ArgumentError.new("version argument must be in the format <x.y.z>") unless /\d+\.\d+\.\d+/ =~ version
    puts "Adding schema for #{type} #{version}"
    cmd = "git submodule add -b #{type}_#{version} https://github.com/rsmp-nordic/rsmp_schema.git schemas/#{type}_#{version}"
    puts "Running: #{cmd}"
    system cmd
  end
end
