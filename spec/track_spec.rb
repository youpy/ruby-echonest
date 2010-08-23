$:.unshift File.dirname(__FILE__)

require 'spec_helper'
require "echonest"

include SpecHelper

describe Echonest::ApiMethods::Track do
  before do
    @api = Echonest::Api.new('8TPE3VC60ODJTNTFE')
    @track = Echonest::ApiMethods::Track.new(@api)
  end

  describe '#profile' do
    it 'should request to track/profile with id' do
      @api.should_receive(:request).with(
        'track/profile',
        :get ,
        :id => 'TRXXHTJ1294CD8F3B3', :bucket => 'audio_summary')

      @track.profile(:id => 'TRXXHTJ1294CD8F3B3')
    end

    it 'should request to track/profile with md5' do
      @api.should_receive(:request).with(
        'track/profile',
        :get ,
        :md5 => '0cf9c7faab913c62451940e6a4eb8a09', :bucket => 'audio_summary')

      @track.profile(:md5 => '0cf9c7faab913c62451940e6a4eb8a09')
    end
  end

  describe '#analyze' do
    it 'should request to track/profile with id' do
      @api.should_receive(:request).with(
        'track/analyze',
        :post ,
        :id => 'TRXXHTJ1294CD8F3B3', :bucket => 'audio_summary')

      @track.analyze(:id => 'TRXXHTJ1294CD8F3B3')
    end

    it 'should request to track/profile with md5' do
      @api.should_receive(:request).with(
        'track/analyze',
        :post,
        :md5 => '0cf9c7faab913c62451940e6a4eb8a09', :bucket => 'audio_summary')

      @track.analyze(:md5 => '0cf9c7faab913c62451940e6a4eb8a09')
    end
  end

  describe '#upload' do
    it 'should upload by url' do
      @api.should_receive(:request).with(
        'track/upload',
        :post ,
        :url => 'http://example.com/foo.mp3', :bucket => 'audio_summary')

      @track.upload(:url => 'http://example.com/foo.mp3')
    end

    it 'should upload by local filename' do
      filename = fixture('sample.mp3')

      @api.should_receive(:request).with(
        'track/upload',
        :post,
        { :bucket => 'audio_summary', :filetype => 'mp3' },
        instance_of(File))

      @track.upload(:filename => filename)
    end
  end

  describe '#analysis_url' do
    it 'should return analysis url' do
      @track.should_receive(:profile).
        with(:md5 => 'c2ee3cfddf1eb8631a928a4f662b587c').
        once.
        and_return(Echonest::Response.new(open(fixture('profile_unknown.json')).read))
      @track.should_receive(:upload).
        with(:filename => fixture('sample.mp3')).
        and_return(Echonest::Response.new(open(fixture('profile.json')).read))
      @track.should_receive(:profile).
        with(:md5 => 'c2ee3cfddf1eb8631a928a4f662b587c').
        once.
        and_return(Echonest::Response.new(open(fixture('profile.json')).read))

      @track.analysis_url(fixture('sample.mp3')).
        should eql('https://echonest-analysis.s3.amazonaws.com:443/TR/TRXXHTJ1294CD8F3B3/3/full.json?Signature=GQMyRUdcO5MUPSHZej72oQHOg3g%3D&Expires=1278605254&AWSAccessKeyId=AKIAJTEJGOTDLQY2E77A')
    end
  end

  describe '#analysis' do
    it 'should return analysis' do
      analysis_url = 'https://echonest-analysis.s3.amazonaws.com:443/TR/TRXXHTJ1294CD8F3B3/3/full.json?Signature=GQMyRUdcO5MUPSHZej72oQHOg3g%3D&Expires=1278605254&AWSAccessKeyId=AKIAJTEJGOTDLQY2E77A'
      @track.should_receive(:analysis_url).with(fixture('sample.mp3')).and_return(analysis_url)
      Echonest::Analysis.should_receive(:new_from_url).with(analysis_url)

      @track.analysis(fixture('sample.mp3'))
    end
  end
end
