$:.unshift File.dirname(__FILE__) + '/../lib/'

require 'echonest'

module SpecHelper
  def fixture(filename)
    File.dirname(__FILE__) + '/fixtures/' + filename
  end
end


