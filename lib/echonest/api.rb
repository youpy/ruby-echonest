# -*- coding: utf-8 -*-
require 'digest/md5'
require 'httpclient'
require 'json'

module Echonest
  class Api
    BASE_URL = 'http://developer.echonest.com/api/v4/'
    USER_AGENT = '%s/%s' % ['ruby-echonest', ::Echonest::VERSION]

    include TraditionalApiMethods

    class Error < StandardError; end

    attr_reader :user_agent

    def initialize(api_key)
      @api_key = api_key
      @user_agent = HTTPClient.new(:agent_name => USER_AGENT)
    end

    def track
      ApiMethods::Track.new(self)
    end

    def build_params(params)
      params = params.
        merge(:format => 'json').
        merge(:api_key => @api_key)
    end

    def request(name, method, params, file = nil)
      if file
        query = build_params(params).sort_by do |param|
          param[0].to_s
        end.inject([]) do |m, param|
          m << [URI.encode(param[0].to_s), URI.encode(param[1])].join('=')
        end.join('&')

        uri = URI.join(BASE_URL, name.to_s)
        uri.query = query

        response_body = @user_agent.__send__(
          method.to_s + '_content',
          uri,
          file.read,
          {
            'Content-Type' => 'application/octet-stream'
          })
      else
        response_body = @user_agent.__send__(
          method.to_s + '_content',
          URI.join(BASE_URL, name.to_s),
          build_params(params))
      end

      response = Response.new(response_body)
      unless response.success?
        raise Error.new(response.status.message)
      end

      response
    rescue HTTPClient::BadResponseError => e
      raise Error.new('%s: %s' % [name, e.message])
    end
  end

  module ApiMethods
    class Base
      def initialize(api)
        @api = api
      end
    end

    class Track < Base
      def profile(options)
        @api.request('track/profile',
          :get,
          options.merge(:bucket => 'audio_summary'))
      end

      def analyze(options)
        @api.request('track/analyze',
          :post,
          options.merge(:bucket => 'audio_summary'))
      end

      def upload(options)
        options.update(:bucket => 'audio_summary')

        if options.has_key?(:filename)
          filename = options.delete(:filename)
          filetype = filename.to_s.match(/\.(mp3|au|ogg)$/)[1]

          open(filename) do |f|
            @api.request('track/upload',
              :post,
              options.merge(:filetype => filetype),
              f)
          end
        else
          @api.request('track/upload', :post, options)
        end
      end

      def analysis(filename)
        analysis_url = analysis_url(filename)
        Analysis.new_from_url(analysis_url)
      end

      def analysis_url(filename)
        md5 = Digest::MD5.hexdigest(open(filename).read)

        while true
          response = profile(:md5 => md5)

          case response.body.track.status
          when 'unknown'
            upload(:filename => filename)
          when 'pending'
            sleep 60
          when 'complete'
            return response.body.track.audio_summary.analysis_url
          when 'error'
            raise Error.new(response.body.track.status)
          when 'unavailable'
            analyze(:md5 => md5)
          end

          sleep 5
        end
      end
    end
  end
end

class HTTPClient
  def agent_name
    @session_manager.agent_name
  end
end
