$:.unshift File.dirname(__FILE__)

require 'spec_helper'

include SpecHelper

describe Echonest::Analysis do
  before do
    @analysis = Echonest::Analysis.new(open(fixture('analysis.json')).read)
  end

  it "should have beats" do
    beats = @analysis.beats

    beats.size.should eql(324)
    beats.first.start.should eql(0.27661)
    beats.first.duration.should eql(0.36476)
    beats.first.confidence.should eql(0.468)
  end

  it "should have segments" do
    segments = @analysis.segments
    segment = segments.first

    segments.size.should eql(274)
    segment.start.should eql(0.0)
    segment.duration.should eql(0.43909)
    segment.confidence.should eql(1.0)
    segment.loudness.time.should eql(0.0)
    segment.loudness.value.should eql(-60.0)
    segment.max_loudness.time.should eql(0.11238)
    segment.max_loudness.value.should eql(-33.563)
    segment.pitches.size.should eql(12)
    segment.pitches.first.should eql(0.138)
    segment.timbre.size.should eql(12)
    segment.timbre.first.should eql(11.525)
  end

  it "should have bars" do
    bars = @analysis.bars

    bars.size.should eql(80)
    bars.first.start.should eql(1.00704)
    bars.first.duration.should eql(1.48532)
    bars.first.confidence.should eql(0.188)
  end

  it "should have tempo" do
    @analysis.tempo.should eql(168.460)
  end

  it "should have sections" do
    sections = @analysis.sections
    section = sections.first

    sections.size.should eql(7)
    section.start.should eql(0.0)
    section.duration.should eql(20.04271)
    section.confidence.should eql(1.0)
  end

  it "should have durtion" do
    @analysis.duration.should eql(120.68526)
  end

  it "should have end of fade in" do
    @analysis.end_of_fade_in.should eql(0.0)
  end

  it "should have start of fade out" do
    @analysis.start_of_fade_out.should eql(113.557)
  end

  it "should have key" do
    @analysis.key.should eql(7)
  end

  it "should have loudness" do
    @analysis.loudness.should eql(-19.140)
  end

  it "should have mode" do
    @analysis.mode.should eql(1)
  end

  it "should have time signature" do
    @analysis.time_signature.should eql(4)
  end

  it "should have tatums" do
    tatums = @analysis.tatums

    tatums.size.should eql(648)
    tatums.first.start.should eql(0.09469)
    tatums.first.duration.should eql(0.18193)
    tatums.first.confidence.should eql(0.286)
  end
end
