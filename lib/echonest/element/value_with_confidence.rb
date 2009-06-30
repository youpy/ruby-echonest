class ValueWithConfidence
  attr_reader :value, :confidence

  def initialize(value, confidence)
    @value = value
    @confidence = confidence
  end
end


