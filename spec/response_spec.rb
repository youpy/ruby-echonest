$:.unshift File.dirname(__FILE__)

require 'spec_helper'

include SpecHelper

describe Echonest::Response do
  before do
    @success = Echonest::Response.new(open(fixture('profile.json')).read)
    @failure = Echonest::Response.new(open(fixture('profile_failure.json')).read)
  end

  it "should return status" do
    @success.status.code.should eql(0)
    @success.status.message.should eql('Success')
    @success.should be_success
    @success.body.track.artist.should eql('Philip Glass')

    @failure.status.code.should eql(1)
    @failure.status.message.should eql('api_key - Invalid key: "XXXXX" is not a valid, active api key')
    @failure.should_not be_success
  end
end
