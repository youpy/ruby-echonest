class Loudness
  attr_reader :time, :value

  def initialize(time, value)
    @time = time
    @value = value
  end
end
