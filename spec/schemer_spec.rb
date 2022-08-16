RSpec.describe RSMP::Schemer do
  it 'has correct schemas' do
    expect(RSMP::Schemer.has_schema?(:bad,'3.1.5')).to be(false)
    expect(RSMP::Schemer.has_schema?(:bad,'1.0.15')).to be(false)

    expect(RSMP::Schemer.has_schema?(:core,'3.1.0')).to be(false)
    expect(RSMP::Schemer.has_schema?(:core,'3.1.1')).to be(true)
    expect(RSMP::Schemer.has_schema?(:core,'3.1.2')).to be(true)
    expect(RSMP::Schemer.has_schema?(:core,'3.1.3')).to be(true)
    expect(RSMP::Schemer.has_schema?(:core,'3.1.4')).to be(true)
    expect(RSMP::Schemer.has_schema?(:core,'3.1.5')).to be(true)
    expect(RSMP::Schemer.has_schema?(:core,'3.1.6')).to be(false)

    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.6')).to be(false)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.7')).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.8')).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.9')).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.10')).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.11')).to be(false)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.12')).to be(false)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.13')).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.14')).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.15')).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.16')).to be(false)
  end

  it 'parses versions strings strictly' do
    expect(RSMP::Schemer.has_schema?(:core,'3.1.5.extra.9.8.7')).to be(false)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.15.extra.9.8.7')).to be(false)
  end

  it 'parses versions strings leniently' do
    expect(RSMP::Schemer.has_schema?(:core,'3.1.5.extra.9.8.7', lenient: true)).to be(true)
    expect(RSMP::Schemer.has_schema?(:tlc,'1.0.15.extra.9.8.7', lenient: true)).to be(true)
  end

  it 'raises when schema not found' do
    expect {
      RSMP::Schemer.find_schema!(:bad,'3.1.5')
    }.to raise_error(RSMP::Schemer::UnknownSchemaTypeError)

    expect {
      RSMP::Schemer.find_schema!(:core,'0.0.0')
    }.to raise_error(RSMP::Schemer::UnknownSchemaVersionError)
  end

  it 'returns nil when schema not found' do
    expect(RSMP::Schemer.find_schema(:bad,'3.1.5')).to be_nil
    expect(RSMP::Schemer.find_schema(:bad,'3.1.5')).to be_nil
  end

  it 'finds schemas or return nil' do
    expect(RSMP::Schemer.find_schemas(:core)).to be_a(Hash)
    expect(RSMP::Schemer.find_schemas(:bad)).to be_nil
  end

  it "raise exception when trying to validate against non-existing version" do
    message = {
      "mType" => "rSMsg",
      "type" => "AggregatedStatusRequest",
      "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
      "cId" => "AB+84001=860SG001"
    }
    expect {
      RSMP::Schemer.validate(message, core: '0.0.1')
    }.to raise_error(RSMP::Schemer::UnknownSchemaVersionError)
  end

end
