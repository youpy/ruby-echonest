$:.unshift File.dirname(__FILE__)

require 'spec_helper'

describe Echonest::Analysis do
  before do
    @analysis = Echonest::Analysis.new(open(fixture('analysis.json')).read)
  end

  it "should have artist" do
    @analysis.artist.should eql("Philip Glass")
  end

  it "should have album" do
    @analysis.album.should eql("The Orange Mountain Music Philip Glass Sampler Vol.I")
  end

  it "should have title" do
    @analysis.title.should eql("Neverwas Restored (from Neverwas Soundtrack)")
  end

  it "should have beats" do
    beats = @analysis.beats

    beats.size.should eql(301)
    beats.first.start.should eql(0.14982)
    beats.first.duration.should eql(0.42958)
    beats.first.confidence.should eql(0.0)
  end

  it "should have segments" do
    segments = @analysis.segments
    segment = segments.first

    segments.size.should eql(339)
    segment.start.should eql(0.0)
    segment.duration.should eql(0.10308)
    segment.confidence.should eql(0.0)
    segment.loudness.time.should eql(0.0)
    segment.loudness.value.should eql(-60.0)
    segment.max_loudness.time.should eql(0.07546)
    segment.max_loudness.value.should eql(-57.86)
    segment.pitches.size.should eql(12)
    segment.pitches.first.should eql(1.0)
    segment.timbre.size.should eql(12)
    segment.timbre.first.should eql(1.178)
  end

  it "should have bars" do
    bars = @analysis.bars

    bars.size.should eql(75)
    bars.first.start.should eql(0.14982)
    bars.first.duration.should eql(1.7004)
    bars.first.confidence.should eql(0.132)
  end

  it "should have tempo" do
    @analysis.tempo.should eql(151.019)
  end

  it "should have sections" do
    sections = @analysis.sections
    section = sections.first

    sections.size.should eql(7)
    section.start.should eql(0.0)
    section.duration.should eql(21.14804)
    section.confidence.should eql(1.0)
  end

  it "should have durtion" do
    @analysis.duration.should eql(120.68)
  end

  it "should have end of fade in" do
    @analysis.end_of_fade_in.should eql(0.10308)
  end

  it "should have start of fade out" do
    @analysis.start_of_fade_out.should eql(115.7863)
  end

  it "should have key" do
    @analysis.key.should eql(7)
  end

  it "should have loudness" do
    @analysis.loudness.should eql(-18.825)
  end

  it "should have mode" do
    @analysis.mode.should eql(1)
  end

  it "should have time signature" do
    @analysis.time_signature.should eql(4)
  end

  it "should have tatums" do
    tatums = @analysis.tatums

    tatums.size.should eql(601)
    tatums.first.start.should eql(0.14982)
    tatums.first.duration.should eql(0.21743)
    tatums.first.confidence.should eql(0.311)
  end
end
