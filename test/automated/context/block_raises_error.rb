require_relative '../../test_init'

context "Context" do
  context "Block Raises Error" do
    return_value = nil

    prose = Controls::Context::Prose.example

    begin
      Controls::Evaluate.() do
        return_value = context "#{prose}" do
          raise Controls::Error.example
        end
      end
    rescue Controls::Error::Example => error
    end

    test "Error is rescued" do
      assert(error.nil?)
    end

    test "Returns false" do
      assert(return_value == false)
    end
  end
end
