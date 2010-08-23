$:.unshift File.dirname(__FILE__)

require 'spec_helper'
require "echonest"

include SpecHelper

describe Echonest::Api do
  before do
    @api = Echonest::Api.new('8TPE3VC60ODJTNTFE')
  end

  it "should have version" do
    Echonest::Api::VERSION.should eql('4.2')
  end

  it "should build parameters" do
    params = @api.build_params(:id => 'TRXXHTJ1294CD8F3B3')
    params.keys.size.should eql(3)
    params[:api_key].should eql('8TPE3VC60ODJTNTFE')
    params[:id].should eql('TRXXHTJ1294CD8F3B3')
    params[:format].should eql('json')
  end

  it "should call api method" do
    content = open(fixture('profile.json')).read

    make_connection_stub(content, :post)
    response = @api.request('track/profile', :post, :id => 'TRXXHTJ1294CD8F3B3')
    response.should be_success
    response.body.status.version.should eql("4.2")
  end

  it "should raise error when api method call was failed" do
    make_connection_stub(open(fixture('profile_failure.json')).read, :post)

    lambda {
      @api.request('track/profile', :post, :id => 'TRXXHTJ1294CD8F3B3')
    }.should raise_error(Echonest::Api::Error, 'api_key - Invalid key: "XXXXX" is not a valid, active api key')
  end

  it "should raise error when unknown api method was called" do
    @api.user_agent.stub!('get_content').and_raise(HTTPClient::BadResponseError.new('error message'))

    lambda {
      @api.request('track/xxxx', :get, :id => 'TRXXHTJ1294CD8F3B3')
    }.should raise_error(Echonest::Api::Error, 'track/xxxx: error message')
  end

  it "should make http request with agent name" do
    @api.user_agent.agent_name.should eql('ruby-echonest/' + Echonest::VERSION)
  end

  def make_connection_stub(content, method)
    @api.user_agent.stub!(method.to_s + '_content').and_return(content)
  end
end
