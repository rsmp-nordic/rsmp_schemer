RSpec.describe RSMP::Schemer do

  it "accepts alarm request in core from 3.1.5," do
    message = {
      "mType" => "rSMsg",
      "type" => "AggregatedStatusRequest",
      "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
      "cId" => "AB+84001=860SG001"
    }
    expect(RSMP::Schemer.validate(message, core: '3.1.4')).to be_a(Array)
    expect(RSMP::Schemer.validate(message, core: '3.1.5')).to be_nil
  end

  it "accepts M0104 in tlc from 1.0.15" do
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
          "cCI" => "M0104",
          "n" => "year",
          "cO" => "setDate",
          "v" => "2021"
        }
      ]
    }
    #expect(RSMP::Schemer.validate(message, tlc: '1.0.14')).to be_a(Array)
    expect(RSMP::Schemer.validate(message, tlc: '1.0.15')).to be_nil
  end

end
