$:.unshift File.dirname(__FILE__)

require 'spec_helper'
require 'fileutils'

describe Echonest::ApiMethods::Track do
  before do
    @api = Echonest::Api.new('8TPE3VC60ODJTNTFE')
    @track = Echonest::ApiMethods::Track.new(@api)
    @cache_path = File.expand_path('~/.echonest/analysis/c2ee3cfddf1eb8631a928a4f662b587c')

    if File.exists?(@cache_path)
      FileUtils.rm @cache_path
    end
  end

  describe '#profile' do
    it 'should request to track/profile with id' do
      @api.should_receive(:request).with(
        'track/profile',
        :get ,
        :id => 'TRXXHTJ1294CD8F3B3',
        :bucket => 'audio_summary')

      @track.profile(:id => 'TRXXHTJ1294CD8F3B3')
    end

    it 'should request to track/profile with md5' do
      @api.should_receive(:request).with(
        'track/profile',
        :get ,
        :md5 => '0cf9c7faab913c62451940e6a4eb8a09',
        :bucket => 'audio_summary')

      @track.profile(:md5 => '0cf9c7faab913c62451940e6a4eb8a09')
    end
  end

  describe '#analyze' do
    it 'should request to track/analyze with id' do
      @api.should_receive(:request).with(
        'track/analyze',
        :post ,
        :id => 'TRXXHTJ1294CD8F3B3',
        :bucket => 'audio_summary')

      @track.analyze(:id => 'TRXXHTJ1294CD8F3B3')
    end

    it 'should request to track/analyze with md5' do
      @api.should_receive(:request).with(
        'track/analyze',
        :post,
        :md5 => '0cf9c7faab913c62451940e6a4eb8a09',
        :bucket => 'audio_summary')

      @track.analyze(:md5 => '0cf9c7faab913c62451940e6a4eb8a09')
    end
  end

  describe '#upload' do
    it 'should upload by url' do
      @api.should_receive(:request).with(
        'track/upload',
        :post ,
        :url => 'http://example.com/foo.mp3',
        :bucket => 'audio_summary')

      @track.upload(:url => 'http://example.com/foo.mp3')
    end

    %w{ wav mp3 au ogg m4a mp4 }.each do |filetype|
      it "should upload '#{filetype}' by local filename" do
        filename = fixture("sample.#{filetype}")

        @api.should_receive(:request).with(
          'track/upload',
          :post,
          { :bucket => 'audio_summary', :filetype => filetype },
          instance_of(File))

        @track.upload(:filename => filename)
      end
    end

    %w{ aif aiff }.each do |filetype|
      it "should upload '#{filetype}' as filetype wav" do
        # we are tricking the echonest api here
        # they do aiff, but only if we pretend it's wav

        filename = fixture("sample.#{filetype}")

        @api.should_receive(:request).with(
          'track/upload',
          :post,
          { :bucket => 'audio_summary', :filetype => 'wav' },
          instance_of(File))

        @track.upload(:filename => filename)
      end
    end

    it "should throw exception if unsupported FileType" do
      filename = fixture("profile.json")

      expect do
        @track.upload(:filename => filename)
      end.to raise_error(Echonest::Api::UnsupportedFiletypeError)
    end
  end

  describe '#analysis_url' do
    it 'should return analysis url' do
      @track.should_receive(:profile).
        with(:md5 => 'c2ee3cfddf1eb8631a928a4f662b587c').
        once.
        and_raise(Echonest::Api::Error.new('The Identifier specified does not exist.: c2ee3cfddf1eb8631a928a4f662b587c'))
      @track.should_receive(:upload).
        with(:filename => fixture('sample.mp3')).
        and_return(Echonest::Response.new(open(fixture('profile.json')).read))

      @track.analysis_url(fixture('sample.mp3'), 'c2ee3cfddf1eb8631a928a4f662b587c').
        should eql('https://echonest-analysis.s3.amazonaws.com:443/TR/TRXXHTJ1294CD8F3B3/3/full.json?Signature=GQMyRUdcO5MUPSHZej72oQHOg3g%3D&Expires=1278605254&AWSAccessKeyId=AKIAJTEJGOTDLQY2E77A')
    end
  end

  describe '#analysis' do
    before do
      @analysis = Echonest::Analysis.new(open(fixture('analysis.json')).read)
      @analysis_url = 'https://echonest-analysis.s3.amazonaws.com:443/TR/TRXXHTJ1294CD8F3B3/3/full.json?Signature=GQMyRUdcO5MUPSHZej72oQHOg3g%3D&Expires=1278605254&AWSAccessKeyId=AKIAJTEJGOTDLQY2E77A'
    end

    it 'should return analysis' do
      @track.should_receive(:analysis_url).with(fixture('sample.mp3'), 'c2ee3cfddf1eb8631a928a4f662b587c').and_return(@analysis_url)
      Echonest::Analysis.should_receive(:new_from_url).with(@analysis_url).and_return(@analysis)

      @track.analysis(fixture('sample.mp3'))
    end

    it 'should cache analysis' do
      File.exist?(@cache_path).should_not be

      # 1st (not cached)
      @track.should_receive(:analysis_url).with(fixture('sample.mp3'), 'c2ee3cfddf1eb8631a928a4f662b587c').and_return(@analysis_url)
      Echonest::Analysis.should_receive(:new_from_url).with(@analysis_url).and_return(@analysis)
      @track.analysis(fixture('sample.mp3'))

      File.exist?(@cache_path).should be
      open(@cache_path).read.should eql(open(fixture('analysis.json')).read)

      # 2nd (cached)
      @track.should_not_receive(:analysis_url)
      Echonest::Analysis.should_receive(:new).with(open(@cache_path).read).and_return(@analysis)
      @track.analysis(fixture('sample.mp3'))
    end
  end
end
