# RSMP Schemer
Gem for validating RSMP messages against RSMP JSON schemas.

## Background
When communicating via RSMP, the version of core and SXL used is negotiated during connection, and can therefore vary depending on who you communicate with.

To validate against the correct version of the JSON schema, all relevant versions need to be avaiable, so you can 

The actual JSON scheme files are maintained in the repo https://github.com/rsmp-nordic/rsmp_schema. Different version of core and SXLs are mainted in different branches.

Each of these branches are included here as submodules, so you can choose which core and SXL version you want to validate against.

The actual validation is performed with the json_schemer gem.

## Usage
Use ```Schemer#validate``` to validate against a particular schema type and version.

Validating against core and sxl schemas is done separately.
The core schema validates everything that's common to all types of equipment/SXLs.
SXL schemas validate the mesage types specific to a type of equipment.

For example, the core schema will validate that a CommandRequest has all the correct attributes, e.g. that there is a command code. The SXL schema will validate the content of the attributes. e.g. that the command code represents a valid command.

If there are validation errors and error will be returned, pointing to the offendig items.  The errors come from the json_schemer gem.

Nil means there are no errors, ie. the message is valid.

Example, validating an an AggregatedStatusRequest:

```ruby
message = {
  "mType" => "rSMsg",
  "type" => "AggregatedStatusRequest",
  "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
  "cId" => "AB+84001=860SG001"
}

# validing using core 3.1.4 will return an error, because the message
# type AggregatedStatusRequest was not introduced until 3.1.5:
errors = RSMP::Schemer.validate(message, core: '3.1.4')
# => [["/type", "enum", nil]]

# The first item '/type' indicate the field with error
# The second item 'enum' indicate an invalid enum valiue

# validating using core 3.1.5 will succeeed, ie. return no errors:
errors = RSMP::Schemer.validate(message, core: '3.1.5')
# => nil

# validate against several schemas:
errors = RSMP::Schemer.validate(message, core: '3.1.5', tlc: '1.0.15')
# => nil
```

