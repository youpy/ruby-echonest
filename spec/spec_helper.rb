$:.unshift File.dirname(__FILE__) + '/../lib/'

require 'echonest'

RSpec.configure do |config|
  def fixture(filename)
    File.dirname(__FILE__) + '/fixtures/' + filename
  end
end
