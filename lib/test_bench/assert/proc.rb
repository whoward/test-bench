module TestBench
  class Assert
    module Proc
      module Assertions
        def raises_error? error_type=nil
          rescue_error_type = error_type || StandardError

          self.call

          return false

        rescue rescue_error_type => error
          return error_type.nil? || error.class == error_type
        end
      end

      ::Proc.send :const_set, :Assertions, Assertions
    end
  end
end
