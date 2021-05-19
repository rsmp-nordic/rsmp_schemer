# frozen_string_literal: true

require 'pathname'
require_relative "lib/rsmp_schemer/version"

Gem::Specification.new do |spec|
  spec.name          = "rsmp_schemer"
  spec.version       = RSMP::Schemer::VERSION
  spec.authors       = ["Emil Tin"]
  spec.email         = ["zf0f@kk.dk"]

  spec.summary       = "Validate RSMP message against RSMP JSON Schema."
  spec.description   = "Validate RSMP message against RSMP JSON Schema. Support validating against core and different SXL's, in different versions."
  spec.homepage      = "https://github.com/rsmp-nordic/rsmp_schemer"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  # Add schema files in submodules inside schema/
  `git submodule --quiet foreach pwd`.split($\).each do |submodule_path|
    Dir.chdir(submodule_path) do
      relative_path = Pathname.new(submodule_path).relative_path_from __dir__
      `git ls-files`.split($\).each do |filename|
        spec.files << relative_path.join(filename).to_s
      end
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json_schemer", "~> 0.2.18"

  spec.add_development_dependency "rspec", "~> 3.9.0"
  spec.add_development_dependency "rspec-expectations", "~> 3.9.1"
  spec.add_development_dependency "rake", "~> 13.0"
end
