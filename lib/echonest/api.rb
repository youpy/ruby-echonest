# -*- coding: utf-8 -*-
require 'digest/md5'
require 'httpclient'
require 'json'
require 'fileutils'
require 'cgi'

module Echonest
  class Api
    BASE_URL = 'http://developer.echonest.com/api/v4/'
    USER_AGENT = '%s/%s' % ['ruby-echonest', ::Echonest::VERSION]

    include TraditionalApiMethods

    class Error < StandardError; end
    class UnsupportedFiletypeError < StandardError; end

    attr_reader :user_agent

    def initialize(api_key = nil)
      @api_key = api_key || read_api_key_from_file
      @user_agent = HTTPClient.new(:agent_name => USER_AGENT)

      # for big files
      @user_agent.send_timeout = 60 * 30
      @user_agent.receive_timeout = 60 * 10
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
          m << [CGI.escape(param[0].to_s), CGI.escape(param[1])].join('=')
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

    def self.api_key_file
      DIRECTORY + 'api_key'
    end

    private

    def read_api_key_from_file
      self.class.api_key_file.read.chomp
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
          filetype = parse_filetype(filename)

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
        md5 = Digest::MD5.hexdigest(open(filename).read)
        cache_path = DIRECTORY + 'analysis' + md5

        if File.exists?(cache_path)
          analysis = Analysis.new(open(cache_path).read)
        else
          analysis = Analysis.new_from_url(analysis_url(filename, md5))
          cache_path.dirname.mkpath
          open(cache_path, 'w') do |file|
            file.write analysis.json
          end
        end

        analysis
      end

      def analysis_url(filename, md5)
        while true
          begin
            response = profile(:md5 => md5)
          rescue Api::Error => e
            if e.message =~ /^The Identifier specified does not exist/
              response = upload(:filename => filename)
            else
              raise
            end
          end

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

      private

      def parse_filetype(filename)
        filetype = filename.to_s.match(/\.(wav|mp3|au|ogg|m4a|mp4|aif|aiff)$/)

        if !filetype
          raise Api::UnsupportedFiletypeError
        elsif ['aif', 'aiff'].include? filetype[1]
          'wav'
        else
          filetype[1]
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
