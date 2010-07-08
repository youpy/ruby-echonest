class Section
  attr_reader :start, :duration, :confidence

  def initialize(start, duration, confidence)
    @start = start
    @duration = duration
    @confidence = confidence
  end
end
