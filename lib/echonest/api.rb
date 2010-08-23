# -*- coding: utf-8 -*-
require 'digest/md5'
require 'httpclient'
require 'json'

module Echonest
  class Api
    VERSION = '4.2'
    BASE_URL = 'http://developer.echonest.com/api/v4/'
    USER_AGENT = '%s/%s' % ['ruby-echonest', ::Echonest::VERSION]

    class Error < StandardError; end

    attr_reader :user_agent

    def initialize(api_key)
      @api_key = api_key
      @user_agent = HTTPClient.new(:agent_name => USER_AGENT)
    end

    def build_params(params)
      params = params.
        merge(:format => 'json').
        merge(:api_key => @api_key)
    end

    def upload(filename)
      open(filename) do |f|
        request(:upload, :post, :file => f)
      end
    end

    def request(name, method, params)
      response_body = @user_agent.__send__(
        method.to_s + '_content',
        URI.join(BASE_URL, name.to_s),
        build_params(params))
      response = Response.new(response_body)

      unless response.success?
        raise Error.new(response.status.message)
      end

      response
    rescue HTTPClient::BadResponseError
      raise Error.new('API method "%s" is unknown' % name)
    end
  end
end

class HTTPClient
  def agent_name
    @session_manager.agent_name
  end
end
