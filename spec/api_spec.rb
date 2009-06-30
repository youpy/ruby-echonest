$:.unshift File.dirname(__FILE__)

require 'spec_helper'
require "echonest"

include SpecHelper

describe Echonest::Api do
  before do
    @api = Echonest::Api.new('5ZAOMB3BUR8QUN4PE')
  end

  it "should have version" do
    Echonest::Api::VERSION.should eql('3')
  end

  it "should build parameters" do
    params = @api.build_params(:id => 'music://id.echonest.com/~/AR/ARH6W4X1187B99274F')
    params.keys.size.should eql(3)
    params[:version].should eql('3')
    params[:api_key].should eql('5ZAOMB3BUR8QUN4PE')
    params[:id].should eql('music://id.echonest.com/~/AR/ARH6W4X1187B99274F')
  end

  it "should call api method" do
    make_connection_stub(<<EOM)
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

    response = @api.request(:get_bars, :id => 'music://id.echonest.com/~/AR/ARH6W4X1187B99274F')
    response.success?.should be_true
  end

  it "should raise error when api method call was failed" do
    make_connection_stub(<<EOM)
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
    lambda {
      @api.request(:get_bars, :id => 'music://id.echonest.com/~/AR/ARH6W4X1187B99274F')
    }.should raise_error(Echonest::Api::Error, 'Invalid API key')
  end

  it "should raise error when unknown api method was called" do
    lambda {
      @api.get_xxx(:id => 'music://id.echonest.com/~/AR/ARH6W4X1187B99274F')
    }.should raise_error(NoMethodError)
  end

  it "should get bars" do
    make_connection_stub(open(fixture('get_bars.xml')).read)

    bars = @api.get_bars(fixture('sample.mp3'))

    bars.should be_an_instance_of(Array)
    bars.size.should eql(80)
    bars.first.start.should eql(0.45717)
    bars.first.confidence.should eql(0.537)
  end

  it "should get beats" do
    make_connection_stub(open(fixture('get_beats.xml')).read)

    beats = @api.get_beats(fixture('sample.mp3'))

    beats.should be_an_instance_of(Array)
    beats.size.should eql(375)
    beats.first.start.should eql(0.45717)
    beats.first.confidence.should eql(0.823)
  end

  it "should get tempo" do
    make_connection_stub(open(fixture('get_tempo.xml')).read)

    tempo = @api.get_tempo(fixture('sample.mp3'))

    tempo.should eql(120.163)
  end

  it "should get segments" do
    make_connection_stub(open(fixture('get_segments.xml')).read)

    segments = @api.get_segments(fixture('sample.mp3'))

    segments.size.should eql(4)

    segment = segments.first

    segment.start.should eql(0.0)
    segment.duration.should eql(0.421)
    segment.loudness.time.should eql(0.0)
    segment.loudness.value.should eql(-60.0)
    segment.max_loudness.time.should eql(0.0)
    segment.max_loudness.value.should eql(-60.0)
    segment.pitches.size.should eql(12)
    segment.pitches.first.should eql(0.542)
    segment.timbre.size.should eql(12)
    segment.timbre.first.should eql(0.0)
  end

  it "should get sections" do
    make_connection_stub(open(fixture('get_sections.xml')).read)

    sections = @api.get_sections(fixture('sample.mp3'))

    sections.size.should eql(16)

    section = sections.first

    section.start.should eql(0.0)
    section.duration.should eql(7.82647)
  end

  it "should get durtion" do
    make_connection_stub(open(fixture('get_duration.xml')).read)

    @api.get_duration(fixture('sample.mp3')).should eql(194.3493)
  end

  it "should get end of fade in" do
    make_connection_stub(open(fixture('get_end_of_fade_in.xml')).read)

    @api.get_end_of_fade_in(fixture('sample.mp3')).should eql(0.421)
  end

  it "should get key" do
    make_connection_stub(open(fixture('get_key.xml')).read)

    key = @api.get_key(fixture('sample.mp3'))

    key.confidence.should eql(1.0)
    key.value.should eql(5)
  end

  it "should get loudness" do
    make_connection_stub(open(fixture('get_loudness.xml')).read)

    loudness = @api.get_loudness(fixture('sample.mp3'))

    loudness.should eql(-8.426)
  end

  it "should get metadata" do
    make_connection_stub(open(fixture('get_metadata.xml')).read)

    metadata = @api.get_metadata(fixture('sample.mp3'))

    metadata['genre'].should eql('Boogaloo')
    metadata['duration'].should eql('194.3493')
  end

  it "should get mode" do
    make_connection_stub(open(fixture('get_mode.xml')).read)

    mode = @api.get_mode(fixture('sample.mp3'))

    mode.confidence.should eql(1.0)
    mode.value.should eql(1)
  end

  it "should get start of fade out" do
    make_connection_stub(open(fixture('get_start_of_fade_out.xml')).read)

    @api.get_start_of_fade_out(fixture('sample.mp3')).should eql(182.44499)
  end

  it "should get tatums" do
    make_connection_stub(open(fixture('get_tatums.xml')).read)

    tatums = @api.get_tatums(fixture('sample.mp3'))

    tatums.should be_an_instance_of(Array)
    tatums.size.should eql(757)
    tatums.first.start.should eql(0.45717)
    tatums.first.confidence.should eql(1.0)
  end

  it "should get time_signature" do
    make_connection_stub(open(fixture('get_time_signature.xml')).read)

    time_signature = @api.get_time_signature(fixture('sample.mp3'))

    time_signature.confidence.should eql(0.064)
    time_signature.value.should eql(4)
  end

  def make_connection_stub(xml)
    @api.connection.stub!(:request).and_return(xml)
  end
end
