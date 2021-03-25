require_relative '../lib/rsmp_schemer.rb'

# What schemas are avaible?
puts "Available schemas: #{RSMP::Schemer.schema_versions}"
puts

['3.1.4','3.1.5'].each do |version|
  puts "Has core schema #{version}: #{RSMP::Schemer.has_schema?(:core,version)}"
end
['1.0.7','1.0.15'].each do |version|
  puts "Has tlc schema #{version}: #{RSMP::Schemer.has_schema?(:tlc,version)}"
end
puts


#validate valid message against core and tlc schemas
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
puts "First let's validate a legit message"
puts "core: #{RSMP::Schemer.validate(message, :core,  '3.1.5') || 'ok'}"
puts "tlc: #{RSMP::Schemer.validate(message, :tlc, '1.0.15') || 'ok'}"
puts


#validate bad message against core and tlc schemas
message = {
  "mType" => "rSMsg",
  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
  "type" => "CommandRequest",
  "siteId" => [
    { "sId" => "RN+SI0001" }
  ],
  "arg" => [
    {
      "cCI" => "M3002",
      "n" => "timeplan",
      "cO" => "setPlan",
      "v" => "1"
    }
  ]
}
puts "Now let's look at a shady message"
puts "core: #{RSMP::Schemer.validate(message, :core,  '3.1.5') || 'ok'}"
puts "tlc: #{RSMP::Schemer.validate(message, :tlc, '1.0.15') || 'ok'}"


