# -*- coding: utf-8 -*-
require 'digest/md5'
require 'httpclient'
require 'json'

module Echonest
  class Api
    VERSION = '4.2 Beta'
    BASE_URL = 'http://beta.developer.echonest.com/api/v4/'
    USER_AGENT = '%s/%s' % ['ruby-echonest', ::Echonest::VERSION]

    class Error < StandardError; end

    attr_reader :user_agent

    def initialize(api_key, format='xml')
      @api_key = api_key
      @user_agent = HTTPClient.new(:agent_name => USER_AGENT)
      @format = format
    end

    def get_bars(filename)
      get_analysys(:get_bars, filename) do |analysis|
        analysis.map do |bar|
          Bar.new(bar['start'], bar['confidence'])
        end
      end
    end

    def get_beats(filename)
      get_analysys(:get_beats, filename) do |analysis|
        analysis.map do |beat|
          Beat.new(beat['start'], beat['confidence'])
        end
      end
    end

    def get_segments(filename)
      get_analysys(:get_segments, filename) do |analysis|
        analysis.map do |segment|
          loudness = Loudness.new(0.0, segment['loudness_start'])
          max_loudness = Loudness.new(segment['loudness_max_time'], segment['loudness_max'])

          Segment.new(
            segment['start'],
            segment['duration'],
            loudness,
            max_loudness,
            segment['pitches'],
            segment['timbre']
            )
        end
      end
    end

    def get_tempo(filename)
      get_analysys(:tempo, filename) do |analysis|
        analysis['track']['tempo']
      end
    end

    def get_sections(filename)
      get_analysys(:get_sections, filename) do |analysis|
        analysis.map do |section|
          Section.new(
            section['start'].to_f,
            section['duration'].to_f
          )
        end
      end
    end

    def get_duration(filename)
      get_analysys(:duration, filename) do |analysis|
        analysis['track']['duration']
      end
    end

    def get_end_of_fade_in(filename)
      get_analysys(:end_of_fade_in, filename) do |analysis|
        analysis['track']['end_of_fade_in']
      end
    end

    def get_key(filename)
      get_analysys(:key, filename) do |analysis|
        ValueWithConfidence.new(analysis['track']['key'], analysis['track']['key_confidence'])
      end
    end

    def get_loudness(filename)
      get_analysys(:loudness, filename) do |analysis|
        analysis['track']['loudness']
      end
    end

    def get_metadata(filename)
      get_analysys(:metadata, filename) do |analysis|
        result = {}
        %w[artist release title samplerate bitrate].each do |key|
          value = analysis.find_first("/response/track/#{key}")
          if value
            result[key] = value.content
          end
        end
        result
      end
    end

    def get_mode(filename)
      get_analysys(:mode, filename) do |analysis|
        ValueWithConfidence.new(analysis['track']['mode'], analysis['track']['mode_confidence'])
      end
    end

    def get_start_of_fade_out(filename)
      get_analysys(:start_of_fade_out, filename) do |analysis|
        analysis['track']['start_of_fade_out']
      end
    end

    def get_tatums(filename)
      get_analysys(:get_tatums, filename) do |analysis|
        analysis.map do |tatum|
          Tatum.new(tatum['start'], tatum['confidence'])
        end
      end
    end

    def get_time_signature(filename)
      get_analysys(:time_signature, filename) do |analysis|
        ValueWithConfidence.new(analysis['track']['time_signature'], analysis['track']['time_signature_confidence'])
      end
    end

    def build_params(params)
      params = params.
        merge(:format => @format).
        merge(:api_key => @api_key)
    end

    def get_analysys(method, filename)
      get_trackinfo(method, filename) do |response|
        if method == :metadata
          yield response.xml
        else
          analysis_url = response.xml.find_first('/response/track/audio_summary/analysis_url').content
          response_body = @user_agent.get(analysis_url)
          analysys_response = JSON.parse(response_body.content)

          unless analysys_response['meta']['status_code'] == 0
            raise Error.new("analyze error: status_code=" + response['meta']['status_code'])
          end

          if method.to_s =~ /^get_/
            key = method.to_s.sub(/^get_/, '')
            yield analysys_response[key]
          else
            yield analysys_response
          end
        end
      end
    end

    def get_trackinfo(method, filename, &block)
      content = open(filename).read
      md5 = Digest::MD5.hexdigest(content)

      begin
        response = get_analysys_previously_uploaded_track(:md5 => md5)
        block.call(response)
      rescue Echonest::Api::Error => e
        case e.message
        when /Analysis not ready/
          sleep 20 # wait for serverside analysis
          get_trackinfo(method, filename, &block)
        when 'Invalid parameter: unknown MD5 file hash'
          upload(filename)
          sleep 60 # wait for serverside analysis
          get_trackinfo(method, filename, &block)
        else
          raise
        end
      end
    end

    def get_analysys_previously_uploaded_track(args)
      md5_or_track_id = args[:md5] ? {:md5 => args[:md5]} : {:id => args[:id]}
      response = request('track/analyze', md5_or_track_id.merge(:bucket => 'audio_summary'))

      unless response.success?
        raise Error.new(response.status.message)
      end

      response
    end

    def get_profile(args, &block)
      md5_or_track_id = args[:md5] ? {:md5 => args[:md5]} : {:id => args[:id]}
      response = request('track/profile', md5_or_track_id)

      unless response.success?
        raise Error.new(response.status.message)
      end

      response
    end

    def upload(filename)
      open(filename) do |f|
        request(:upload, :file => f)
      end
    end

    def request(name, params)
      method = (name == :upload || :analyze ? 'post' : 'get')
      response_body = @user_agent.__send__(method + '_content', URI.join(BASE_URL, name.to_s), build_params(params))
      response = Response.new(response_body)

      unless response.success?
        raise Error.new(response.status.message)
      end

      response
    end
  end
end

class HTTPClient
  def agent_name
    @session_manager.agent_name
  end
end
