require_relative '../../test_init'

context "Refute" do
  context "Pass" do
    [nil, false].each do |value|
      context "Value: #{value.inspect}" do
        begin
          Controls::Evaluate.() do
            refute(value)
          end
        rescue TestBench::Assert::Failure => error
        end

        test "Does not raise error" do
          assert(error.nil?)
        end
      end
    end
  end

  context "Fail" do
    value = Object.new

    begin
      Controls::Evaluate.() do
        refute(value)
      end
    rescue TestBench::Assert::Failure => error
    end

    test "Raises error" do
      refute(error.nil?)
    end
  end
end
