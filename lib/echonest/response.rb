require 'json'
require 'hashie'

module Echonest
  class Response
    attr_reader :json

    def initialize(body)
      @json = Hashie::Mash.new(JSON.parse(body))
    end

    def status
      @status ||= Status.new(body)
    end

    def success?
      status.code == Status::SUCCESS
    end

    def body
      json.response
    end

    class Status
      UNKNOWN_ERROR = -1
      SUCCESS = 0
      INVALID_API_KEY = 1
      PERMISSION_DENIED = 2
      RATE_LIMIT_EXCEEDED = 3
      MISSING_PARAMETER = 4
      INVALID_PARAMETER = 5

      attr_reader :code, :message

      def initialize(response_body)
        @code = response_body.status.code
        @message = response_body.status.message
      end
    end
  end
end
