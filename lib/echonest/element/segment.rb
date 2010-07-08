class Segment < Section
  attr_reader :loudness, :max_loudness, :pitches, :timbre

  def initialize(start, duration, confidence, loudness, max_loudness, pitches, timbre)
    super(start, duration, confidence)

    @loudness = loudness
    @max_loudness = max_loudness
    @pitches = pitches
    @timbre = timbre
  end
end
