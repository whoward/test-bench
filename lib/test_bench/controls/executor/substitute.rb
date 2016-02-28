module TestBench
  module Controls
    module Executor
      class Substitute
        def add *files
          added_files.concat files
        end

        def added_files
          @added_files ||= []
        end

        def call telemetry
          added_files.each do |file|
            telemetry.file_started file
            executed_files << file
            telemetry.file_finished file
          end
        end

        def executed_files
          @executed_files ||= []
        end

        module Assertions
          def executed? *files
            files.all? do |file|
              executed_files.include? file
            end
          end
        end
      end
    end
  end
end
