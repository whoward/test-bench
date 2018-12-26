module TestBench
  module Output
    class Format
      module Dependency
        attr_writer :format
        def format
          @format ||= Format::Substitute.new
        end
      end
    end
  end
end
