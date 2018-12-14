require_relative '../../test_init'

context "Test" do
  context "Abort on Error Setting" do
    prose = Controls::Test::Prose.example

    context "Enabled" do
      abort_on_error = true

      context "Block Raises Error" do
        begin
          Controls::Evaluate.() do
            test "#{prose}", abort_on_error: abort_on_error do
              raise Controls::Error.example
            end
          end
        rescue SystemExit => system_exit
        end

        test "System exit is raised" do
          refute(system_exit.nil?)
        end

        test "Exit status indicates failure" do
          refute(system_exit.success?)
        end
      end
    end

    context "Disabled" do
      abort_on_error = false

      context "Block Raises Error" do
        begin
          Controls::Evaluate.() do
            test "#{prose}", abort_on_error: abort_on_error do
              raise Controls::Error.example
            end
          end
        rescue SystemExit => system_exit
        end

        test "System exit is not raised" do
          assert(system_exit.nil?)
        end
      end
    end
  end
end
