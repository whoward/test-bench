require_relative '../../test_init'

context "Test" do
  context "Block Raises Error" do
    return_value = nil

    prose = Controls::Test::Prose.example

    begin
      Controls::Evaluate.() do
        return_value = test "#{prose}" do
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
