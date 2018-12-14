require_relative '../../test_init'

context "Context" do
  context "No Block Argument" do
    return_value = nil

    prose = Controls::Context::Prose.example

    Controls::Evaluate.() do
      return_value = context "#{prose}"
    end

    test "Returns false" do
      assert(return_value == false)
    end
  end
end
