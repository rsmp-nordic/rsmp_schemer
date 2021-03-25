require 'json_schemer'

module RSMP
  module Schemer

    class UnknownSchemaError < StandardError
    end

    # load schemas
    schemas_path = File.expand_path( File.join(__dir__,'..','..','schemas') )
    @@schemers = {
      core: {
        '3.1.4' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'core_3.1.4/schema/core/rsmp.json')) ),
        '3.1.5' => JSONSchemer.schema( Pathname.new(File.join(schemas_path, 'core_3.1.5/schema/core/rsmp.json')) )
      },
      tlc: {
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
      types = @@schemers[type]
      raise UnknownSchemaError.new("#{type} schema not found") unless types
      schema = types[version]
      raise UnknownSchemaError.new("#{type} #{version} schema not found") unless schema
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
      errors = schemas.flat_map do |type, version|
        schema = find_schema type, version
        validate_with_schemer(message, schema)
      end
      return nil if errors.empty?
      errors
    end

  end
end
