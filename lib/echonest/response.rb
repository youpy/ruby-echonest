require "xml"

module Echonest
  class Response
    attr_reader :xml

    def initialize(body)
      @xml = XML::Document.string(body)
    end

    def status
      @status ||= Status.new(@xml)
    end

    def success?
      status.code == Status::SUCCESS
    end

    def query
      @query ||= Query.new(@xml)
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

      def initialize(xml)
        @code = xml.find('/response/status/code').first.content.to_s.to_i
        @message = xml.find('/response/status/message').first.content.to_s
      end
    end

    class Query
      def initialize(xml)
        @parameters = {}

        xml.find('/response/query/parameter').each do |parameter|
          @parameters[parameter['name'].to_sym] = parameter.content
        end
      end

      def [](parameter_name)
        @parameters[parameter_name]
      end
    end
  end
end
