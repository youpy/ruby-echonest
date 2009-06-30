require 'echonest/version'
require 'echonest/api'
require 'echonest/connection'
require 'echonest/response'
require 'echonest/element/value_with_confidence'
require 'echonest/element/bar'
require 'echonest/element/beat'
require 'echonest/element/section'
require 'echonest/element/segment'
require 'echonest/element/loudness'
require 'echonest/element/tatum'

def Echonest(api_key) Echonest::Api.new(api_key) end

module Echonest
end
