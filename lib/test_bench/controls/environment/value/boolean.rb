module TestBench
  module Controls
    module Environment
      module Value
        module Boolean
          module True
            def self.example
              list.sample
            end

            def self.list
              %w(
                yes
                YES
                Yes
                y
                Y
                true
                TRUE
                True
                t
                T
                on
                ON
                On
                enabled
                ENABLED
                Enabled
                1
              )
            end
          end

          module False
            def self.example
              list.sample
            end

            def self.list
              %w(
                no
                NO
                No
                n
                N
                false
                FALSE
                False
                f
                F
                off
                OFF
                Off
                disabled
                DISABLED
                Disabled
                0
              )
            end
          end

          module Anomaly
            def self.example
              'anomaly'
            end
          end
        end
      end
    end
  end
end
