require_relative '../automated_init'

context "Refute" do
  context "Subject" do
    context "No Assertions Module" do
      RefuteSubjectNoAssertionsModuleExample = Class.new

      subject = RefuteSubjectNoAssertionsModuleExample.new

      test "Raises error" do
        # Raises error due to missing assertions module
        refute(subject) do
          # ...
        end
      end
    end

    context "Assertions Module" do
      class RefuteSubjectHasAssertionsModuleExample
        module Assertions
          def assertions_module?
            true
          end
        end

        module OtherAssertions
          def other_assertions_module?
            true
          end
        end
      end

      subject = RefuteSubjectHasAssertionsModuleExample.new

      test "Example" do
        refute(subject) do
          # Does not raise error
          assertions_module?

          refute(true)
        end
      end

      context "Block Raises Assertion Failure" do
        test "Example" do
          # Passes because block has one or more failed assertions
          refute(subject) do
            assert(false)
          end
        end
      end

      context "Block Does Not Raise Assertion Failure" do
        test "Example" do
          # Fails because block does not have one or more failed assertions
          refute(subject) do
            # ...
          end
        end
      end

      context "Block Raises Other Error" do
        test "Example" do
          # Fails because block raises unrelated error
          refute(subject) do
            fail
          end
        end
      end

      context "Not Overridden" do
        test "Block argument" do
          block_argument = nil

          refute(subject) do |arg|
            block_argument = arg

            refute(true)
          end

          # block_argument is subject
          comment block_argument
        end

        test "Block evaluation context" do
          block_evaluation_context = nil

          refute(subject) do
            block_evaluation_context = self

            refute(true)
          end

          # block_evaluation_context is subject
          comment block_evaluation_context
        end
      end

      context "Overridden" do
        test "Example" do
          refute(subject, subject.class::OtherAssertions) do
            # Does not raise error
            other_assertions_module?

            refute(true)
          end
        end
      end
    end
  end
end
