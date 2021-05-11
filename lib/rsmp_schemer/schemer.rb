require 'json_schemer'

module RSMP
  module Schemer

    class UnknownSchemaError < StandardError
    end

    # load schemas
    schemas_path = File.expand_path( File.join(__dir__,'..','..','schemas') )
    @@schemers = {
      core: {
        '3.1.2' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'core_3.1.2/schema/core/rsmp.json')) ),
        '3.1.3' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'core_3.1.3/schema/core/rsmp.json')) ),
        '3.1.4' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'core_3.1.4/schema/core/rsmp.json')) ),
        '3.1.5' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'core_3.1.5/schema/core/rsmp.json')) )
      },
      # note that tlc 1.0.11 and 1.0.12 does not exist (unreleased drafts)
      tlc: {
        '1.0.7' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'tlc_1.0.7/schema/tlc/sxl.json')) ),
        '1.0.8' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'tlc_1.0.8/schema/tlc/sxl.json')) ),
        '1.0.9' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'tlc_1.0.9/schema/tlc/sxl.json')) ),
        '1.0.10' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'tlc_1.0.10/schema/tlc/sxl.json')) ),
        '1.0.13' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'tlc_1.0.13/schema/tlc/sxl.json')) ),
        '1.0.14' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'tlc_1.0.14/schema/tlc/sxl.json')) ),
        '1.0.15' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'tlc_1.0.15/schema/tlc/sxl.json')) )
      }
    }

    @@versions = {
      core: @@schemers[:core].keys,
      tlc: @@schemers[:tlc].keys
    }

    def self.validate_with_schemer message, schemer
      unless schemer.valid? message
        schemer.validate(message).map do |item|
          [item['data_pointer'],item['type'],item['details']]
        end
      else
        []
      end
    end

    def self.find_schema type, version
      raise ArgumentError.new("type missing") unless type
      raise ArgumentError.new("version missing") unless version

      types = @@schemers[type.to_sym]
      raise UnknownSchemaError.new("Schema #{type} not found") unless types
      schema = types[version]
      raise UnknownSchemaError.new("Schema #{type} #{version} not found") unless schema
      schema
    end

    def self.schemas
      @@schemas
    end

    def self.schema_versions
      @@versions
    end

    def self.has_schema? type, version
      return false unless @@versions[type]
      @@versions[type].include?(version)
    end

    def self.validate message, schemas
      raise ArgumentError unless message && schemas
      raise ArgumentError unless schemas.is_a?(Hash) and schemas.any?
      errors = schemas.flat_map do |type, version|
        schema = find_schema type, version
        validate_with_schemer(message, schema)
      end
      return nil if errors.empty?
      errors
    end

  end
end
