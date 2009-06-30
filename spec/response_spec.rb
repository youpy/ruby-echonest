$:.unshift File.dirname(__FILE__)

require 'spec_helper'
require "echonest"

include SpecHelper

describe Echonest::Response do
  before do
    @success = Echonest::Response.new(<<EOM)
<?xml version="1.0" encoding="UTF-8"?>
<response version="3">
  <status>
    <code>0</code>
    <message>Success</message>
  </status>
  <query>
    <parameter name="api_key">5ZAOMB3BUR8QUN4PE</parameter>
    <parameter name="id">music://id.echonest.com/~/AR/ARH6W4X1187B99274F</parameter>
  </query>
  <artist>
    <name>Radiohead</name>
    <id>music://id.echonest.com/~/AR/ARH6W4X1187B99274F</id>
    <foreign_id>music://id.echonest.com/5ZAOMB3BUR8QUN4PE/AR/1</foreign_id>
    <familiarity>0.96974159665</familiarity>
  </artist>
</response>
EOM

    @failure = Echonest::Response.new(<<EOM)
<?xml version="1.0" encoding="UTF-8"?>
<response version="3">
  <status>
    <code>1</code>
    <message>Invalid API key</message>
  </status>
  <query>
    <parameter name="api_key">XXXXXX</parameter>
    <parameter name="id">music://id.echonest.com/~/AR/ARH6W4X1187B99274F</parameter>
  </query>
</response>
EOM
  end

  it "should return status" do
    @success.status.code.should eql(0)
    @success.status.message.should eql('Success')
    @success.success?.should be_true
    @success.xml.elements['response/artist/name'][0].to_s.should eql('Radiohead')

    @failure.status.code.should eql(1)
    @failure.status.message.should eql('Invalid API key')
    @failure.success?.should be_false
  end

  it "should return query" do
    @success.query[:id].should eql('music://id.echonest.com/~/AR/ARH6W4X1187B99274F')
    @success.query[:api_key].should eql('5ZAOMB3BUR8QUN4PE')
  end
end
