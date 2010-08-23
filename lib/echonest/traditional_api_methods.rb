module Echonest
  module TraditionalApiMethods
    def self.included(c)
      %w/tempo duration end_of_fade_in key loudness mode start_of_fade_out time_signature bars beats sections tatums segments/.
        each do |method|
        c.module_eval %Q{
          def get_%s(filename)
            track.analysis(filename).%s
          end
        } % [method, method]
      end
    end
  end
end
