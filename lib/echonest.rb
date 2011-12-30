require 'echonest/version'
require 'echonest/traditional_api_methods'
require 'echonest/api'
require 'echonest/analysis'
require 'echonest/response'
require 'echonest/element/section'
require 'echonest/element/bar'
require 'echonest/element/beat'
require 'echonest/element/segment'
require 'echonest/element/loudness'
require 'echonest/element/tatum'

require 'pathname'

def Echonest(api_key) Echonest::Api.new(api_key) end

module Echonest
  DIRECTORY = Pathname.new("~/.echonest").expand_path
end
