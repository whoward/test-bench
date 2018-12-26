module TestBench
  module Controls
    module Error
      def self.example(message: nil, backtrace: nil)
        message ||= self.message
        backtrace ||= Backtrace.example

        error = Example.new(message)
        error.set_backtrace(backtrace)
        error
      end

      def self.message
        'Some error'
      end

      Example = Class.new(RuntimeError)

      module Backtrace
        def self.example
          [
            "some_directory/some_file.rb:3:in `block (2 levels) in <main>'",
            "filter_match/other_file.rb:11:in `other_method'",
            "some_directory/some_file.rb:2:in `block in <main>'",
            "filter_match/some_file.rb:111:in `method_3'",
            "filter_match/some_file.rb:11:in `method_2'",
            "some_directory/some_file.rb:1:in `<main>'"
          ]
        end
      end

      module Output
        def self.text
          backtrace = Backtrace.example

          <<~TEXT
          #{backtrace[0]}: Some error (TestBench::Controls::Error::Example)
          \tfrom #{backtrace[1]}
          \tfrom #{backtrace[2]}
          \tfrom #{backtrace[3]}
          \tfrom #{backtrace[4]}
          \tfrom #{backtrace[5]}
          TEXT
        end

        module Reversed
          def self.text
            backtrace = Backtrace.example

            <<~TEXT
            \tfrom #{backtrace[5]}
            \tfrom #{backtrace[4]}
            \tfrom #{backtrace[3]}
            \tfrom #{backtrace[2]}
            \tfrom #{backtrace[1]}
            #{backtrace[0]}: Some error (TestBench::Controls::Error::Example)
            TEXT
          end

          module Filtered
            def self.text
              backtrace = Backtrace.example

              <<~TEXT
              \tfrom #{backtrace[5]}
              \tfrom (filtered)
              \tfrom #{backtrace[2]}
              \tfrom (filtered)
              #{backtrace[0]}: Some error (TestBench::Controls::Error::Example)
              TEXT
            end
          end
        end

        module Filtered
          def self.text
            backtrace = Backtrace.example

            <<~TEXT
            #{backtrace[0]}: Some error (TestBench::Controls::Error::Example)
            \tfrom (filtered)
            \tfrom #{backtrace[2]}
            \tfrom (filtered)
            \tfrom #{backtrace[5]}
            TEXT
          end

          Reversed = Reversed::Filtered
        end
      end
    end
  end
end
