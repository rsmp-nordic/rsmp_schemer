require 'json_schemer'

module RSMP
end

module RSMP::Schemer
  @@schemas = nil

  def self.schemas
    return @@schemas if @@schemas
    schemas_path = File.expand_path( File.join(__dir__,'..','..','schemas') )
    @@schemas = {
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
  end

  def self.validate_using_schema message, schema
    raise ArgumentError.new("message missing") unless message
    raise ArgumentError.new("schema missing") unless schema
    unless schema.valid? message
      schema.validate(message).map do |item|
        [item['data_pointer'],item['type'],item['details']]
      end
    else
      []
    end
  end

  def self.find_schemas type
    raise ArgumentError.new("type missing") unless type
    schemas[type.to_sym]
  end

  def self.find_schemas! type
    schemas = find_schemas type
    raise UnknownSchemaTypeError.new("Unknown schema type #{type}") unless schemas
    schemas
  end

  def self.find_schema type, version
    raise ArgumentError.new("version missing") unless version
    schemas = find_schemas type
    if schemas
      schemas[version] 
    else
      nil
    end
  end

  def self.find_schema! type, version
    raise ArgumentError.new("version missing") unless version
    schemas = find_schemas! type
    schema = schemas[version]
    raise UnknownSchemaVersionError.new("Unknown schema version #{type} #{version}") unless schema
    schema
  end

  def self.has_schema? type, version
    find_schema(type,version) != nil
  end

  def self.validate message, schemas
    raise ArgumentError.new("message missing") unless message
    raise ArgumentError.new("schemas missing") unless schemas
    raise ArgumentError.new("schemas must be a Hash") unless schemas.is_a?(Hash)
    raise ArgumentError.new("schemas cannot be empty") unless schemas.any?
    errors = schemas.flat_map do |type, version|
      schema = find_schema! type, version
      validate_using_schema(message, schema)
    end
    return nil if errors.empty?
    errors
  end

end
