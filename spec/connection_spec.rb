$:.unshift File.dirname(__FILE__)

require 'spec_helper'
require "echonest"

include SpecHelper

describe Echonest::Connection do
  before do
    @connection = Echonest::Connection.new(Echonest::Api::URL)
  end

  it "should make http request with user agent" do
    req = @connection.make_request(URI('http://example.com/xxx'), 'get')

    req.method.should eql('GET')
    req['User-Agent'].should eql('ruby-echonest/' + Echonest::VERSION)
  end
end
