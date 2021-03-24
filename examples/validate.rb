require 'json_schemer'

message = {
  "mType" => "rSMsg",
  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
  "type" => "CommandRequest",
  "siteId" => [
    { "sId" => "RN+SI0001" }
  ],
  "cId" => "O+14439=481WA001",
  "arg" => [
    {
      "cCI" => "M0002",
      "n" => "timeplan",
      "cO" => "setPlan",
      "v" => "1"
    }
  ]
}

# load schemas
$schema_paths = {
  core: Pathname.new('core/schema/core/rsmp.json'),
  tlc: Pathname.new('tlc/schema/tlc/sxl.json')
}

$schemers = {
  core: JSONSchemer.schema($schema_paths[:core]),
  tlc: JSONSchemer.schema($schema_paths[:tlc]),
}

def validate_with message, schemer
  unless schemer.valid? message
    schemer.validate(message).map do |item|
      [item['data_pointer'],item['type'],item['details']].compact.join(' ')
    end
  end
end

def validate message, type
  validate_with message, $schemers[type]
end

#validate message against core and tlc schemas
puts "core: #{validate(message, :core) || 'ok'}"
puts "tlc: #{validate(message, :tlc) || 'ok'}"

