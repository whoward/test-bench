module TestBench
  module Output
    class RenderError
      module Dependency
        attr_writer :render_error
        def render_error
          @render_error ||= RenderError.new
        end
      end
    end
  end
end
