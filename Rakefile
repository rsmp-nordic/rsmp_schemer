# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

namespace :schema do
  task :add do
    type = ENV['type']
    version = ENV['version']
    raise ArgumentError.new("type argument is missing") unless /\w+/ =~ type
    raise ArgumentError.new("version argument must be in the format <x.y.z>") unless /\d+\.\d+\.\d+/ =~ version
    puts "Add schema for #{type} #{version}"
    cmd = "Running: git submodule add -b #{type}_#{version} https://github.com/rsmp-nordic/rsmp_schema.git schemas/#{type}_#{version}"
    puts cmd
  end
end
