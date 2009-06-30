require 'cgi'
require 'net/https'

module Echonest
  class Connection
     def initialize(base_url)
       @base_url = base_url
     end

    def get(resource, args = nil)
      url = url(resource.to_s)

      if args
        url.query = query(args)
      end

      req = make_request(url, 'get')

      request(req, url)
    end

    def post(resource, args = nil)
      url = url(resource.to_s)
      req = make_request(url, 'post')

      if args
        data = post_data(args)
        req['Content-Length'] = data.size.to_s
        req['Content-Type'] = "multipart/form-data; boundary=#{boundary}"
      end

      request(req, url, data)
    end

    def url(path)
      URI.join(@base_url, path)
    end

    def post_data(params)
      data = params.inject([]) do |memo, param|
        name, value = param

        memo << "--#{boundary}"

        if name.to_s == 'file'
          memo << "Content-Disposition: form-data; name=\"#{name}\"; filename=\"file.mp3\""
          memo << "Content-Type: application/octet-stream"
        else
          memo << "Content-Disposition: form-data; name=\"#{name}\""
        end

        memo << ''
        memo << value
      end

      data << "--#{boundary}--"
      data << ''

      data.join("\r\n")
    end

    def boundary
      '----BOUNDARYBOUNDARY----'
    end

    def request(req, url, data = nil)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.port == 443)

      res = http.start() { |conn| conn.request(req, data) }
      res.body
    end

    def query(params)
      params.map { |k,v| "%s=%s" % [CGI.escape(k.to_s), CGI.escape(v.to_s)] }.join("&")
    end

    def make_request(uri, method)
      req = (method == 'post' ? Net::HTTP::Post : Net::HTTP::Get).new(uri.request_uri)
      req['User-Agent'] = user_agent

      req
    end

    def user_agent
      '%s/%s' % ['ruby-echonest', VERSION]
    end
  end
end
