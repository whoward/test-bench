module TestBench
  module Controls
    module Environment
      module Value
        module Color
          Enabled = Boolean::True
          Disabled = Boolean::False
          Anomaly = Boolean::Anomaly

          module Detect
            def self.example
              list.sample
            end

            def self.list
              %w(
                auto
                AUTO
                Auto
                detect
                Detect
                DETECT
              )
            end
          end
        end
      end
    end
  end
end
