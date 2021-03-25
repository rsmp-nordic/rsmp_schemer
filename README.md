# RSMP Schemer
Gem for validating RSMP messages against RSMP JSON schemas.

## Background
When communicating via RSMP, the version of core and SXL used is negotiated during connection, and can therefore vary depending on who you communicate with.

To validate against the correct version of the JSON schema, all relevant versions need to be avaiable.

The actual JSON scheme files are maintained in the repo https://github.com/rsmp-nordic/rsmp_schema. Different version of core and SXLs are mainted in different branches.

Each of these branches are included here as submodules, so you can choose which core and SXL version you want to validate against.

The actual validation is performed with the json_schemer gem.
