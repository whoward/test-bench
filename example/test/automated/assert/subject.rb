require_relative '../automated_init'

context "Assert" do
  context "Subject" do
    context "No Assertions Module" do
      AssertSubjectNoAssertionsModuleExample = Class.new

      subject = AssertSubjectNoAssertionsModuleExample.new

      test "Raises error" do
        # Raises error due to missing assertions module
        assert(subject) do
          # ...
        end
      end
    end

    context "Assertions Module" do
      class AssertSubjectHasAssertionsModuleExample
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

      subject = AssertSubjectHasAssertionsModuleExample.new

      test "Example" do
        assert(subject) do
          assertions_module?
        end
      end

      context "Block Does Not Raise Assertion Failure" do
        test "Example" do
          # Passes because all assertions in block pass
          assert(subject) do
            # ...
          end
        end
      end

      context "Block Raises Assertion Failure" do
        test "Example" do
          # Fails because block has one or more failed assertions
          assert(subject) do
            assert(false)
          end
        end
      end

      context "Block Raises Other Error" do
        test "Example" do
          # Fails because block raises unrelated error
          assert(subject) do
            fail
          end
        end
      end

      context "Not Overridden" do
        test "Block argument" do
          block_argument = nil

          assert(subject) do |arg|
            block_argument = arg
          end

          # block_argument is subject
          comment block_argument
        end

        test "Block evaluation context" do
          block_evaluation_context = nil

          assert(subject) do
            block_evaluation_context = self
          end

          # block_evaluation_context is subject
          comment block_evaluation_context
        end
      end

      context "Overridden" do
        test "Example" do
          assert(subject, subject.class::OtherAssertions) do
            # Does not raise error
            other_assertions_module?
          end
        end
      end
    end
  end
end
