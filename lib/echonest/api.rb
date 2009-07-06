require 'digest/md5'

module Echonest
  class Api
    VERSION = '3'
    URL = 'http://developer.echonest.com/api/'

    class Error < StandardError; end

    attr_reader :connection

    def initialize(api_key)
      @api_key = api_key
      @connection = Connection.new(URL)
    end

    def get_bars(filename)
      get_analysys(:get_bars, filename) do |analysis|
        analysis.map do |bar|
          Bar.new(bar.content.to_f, bar['confidence'].to_f)
        end
      end
    end

    def get_beats(filename)
      get_analysys(:get_beats, filename) do |analysis|
        analysis.map do |beat|
          Beat.new(beat.content.to_f, beat['confidence'].to_f)
        end
      end
    end

    def get_segments(filename)
      get_analysys(:get_segments, filename) do |analysis|
        analysis.map do |segment|
          max_loudness = loudness = nil

          segment.find('loudness/dB').map do |db|
            if db['type'] == 'max'
              max_loudness = Loudness.new(db['time'].to_f, db.content.to_f)
            else
              loudness = Loudness.new(db['time'].to_f, db.content.to_f)
            end
          end

          pitches = segment.find('pitches/pitch').map do |pitch|
            pitch.content.to_f
          end

          timbre = segment.find('timbre/coeff').map do |coeff|
            coeff.content.to_f
          end

          Segment.new(
            segment['start'].to_f,
            segment['duration'].to_f,
            loudness,
            max_loudness,
            pitches,
            timbre
            )
        end
      end
    end

    def get_tempo(filename)
      get_analysys(:get_tempo, filename) do |analysis|
        analysis.first.content.to_f
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
      get_analysys(:get_duration, filename) do |analysis|
        analysis.first.content.to_f
      end
    end

    def get_end_of_fade_in(filename)
      get_analysys(:get_end_of_fade_in, filename) do |analysis|
        analysis.first.content.to_f
      end
    end

    def get_key(filename)
      get_analysys(:get_key, filename) do |analysis|
        ValueWithConfidence.new(analysis.first.content.to_i, analysis.first['confidence'].to_f)
      end
    end

    def get_loudness(filename)
      get_analysys(:get_loudness, filename) do |analysis|
        analysis.first.content.to_f
      end
    end

    def get_metadata(filename)
      get_analysys(:get_metadata, filename) do |analysis|
        analysis.inject({}) do |memo, key|
          memo[key.name] = key.content
          memo
        end
      end
    end

    def get_mode(filename)
      get_analysys(:get_mode, filename) do |analysis|
        ValueWithConfidence.new(analysis.first.content.to_i, analysis.first['confidence'].to_f)
      end
    end

    def get_start_of_fade_out(filename)
      get_analysys(:get_start_of_fade_out, filename) do |analysis|
        analysis.first.content.to_f
      end
    end

    def get_tatums(filename)
      get_analysys(:get_tatums, filename) do |analysis|
        analysis.map do |tatum|
          Tatum.new(tatum.content.to_f, tatum['confidence'].to_f)
        end
      end
    end

    def get_time_signature(filename)
      get_analysys(:get_time_signature, filename) do |analysis|
        ValueWithConfidence.new(analysis.first.content.to_i, analysis.first['confidence'].to_f)
      end
    end

    def build_params(params)
      params = params.
        merge(:version => VERSION).
        merge(:api_key => @api_key)
    end

    def get_analysys(method, filename)
      get_trackinfo(method, filename) do |response|
        yield response.xml.find('/response/analysis').first
      end
    end

    def get_trackinfo(method, filename, &block)
      content = open(filename).read
      md5 = Digest::MD5.hexdigest(content)

      begin
        response = request(method, :md5 => md5)

        block.call(response)
      rescue Error => e
        if e.message == 'Invalid parameter: unknown MD5 file hash'
          upload(filename)
          sleep 60 # wait for serverside analysis
          get_trackinfo(method, filename, &block)
        else
          raise
        end
      end
    end

    def upload(filename)
      content = open(filename).read

      request(:upload, :file => content)
    end

    def request(name, params)
      response_body = @connection.__send__(
        name == :upload ? :post : :get,
        name,
        build_params(params))
      response = Response.new(response_body)

      unless response.success?
        raise Error.new(response.status.message)
      end

      response
    end
  end
end
