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

  it "should pass arguments to user agent" do
    @api.user_agent.should_receive(:get_content).
      with(
      URI('http://developer.echonest.com/api/v4/xxx/yyy'),
      {
        :foo => 'bar',
        :api_key => '8TPE3VC60ODJTNTFE',
        :format => 'json'
      }).and_return(open(fixture('profile.json')).read)

    @api.request('xxx/yyy', :get, :foo => 'bar')
  end

  it "should pass arguments including a file to user agent" do
    file = open(fixture('sample.mp3'))
    file.should_receive(:read).and_return('content')

    @api.user_agent.should_receive(:post_content).
      with(
      URI('http://developer.echonest.com/api/v4/xxx/zzz?api_key=8TPE3VC60ODJTNTFE&bar=baz&format=json'),
      'content',
      {
        'Content-Type' => 'application/octet-stream'
      }).and_return(open(fixture('profile.json')).read)

    @api.request('xxx/zzz', :post, { :bar => 'baz' }, file)
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

  describe '#track' do
    it 'should return track methods' do
      track = @api.track
      track.class.should eql(Echonest::ApiMethods::Track)
      track.instance_eval { @api }.should eql(@api)
    end
  end

  describe 'traditional API methods' do
    it 'should have traditional API methods' do
      filename = fixture('sample.mp3')
      analysis = Echonest::Analysis.new(open(fixture('analysis.json')).read)
      track = Echonest::ApiMethods::Track.new(@api)

      %w/tempo duration end_of_fade_in key loudness mode start_of_fade_out time_signature bars beats sections tatums segments/.
        each do |method|

        @api.should_receive(:track).and_return(track)
        track.should_receive(:analysis).with(filename).and_return(analysis)
        analysis.should_receive(method.to_sym)

        @api.send('get_' + method, filename)
      end
    end
  end

  def make_connection_stub(content, method)
    @api.user_agent.stub!(method.to_s + '_content').and_return(content)
  end
end
