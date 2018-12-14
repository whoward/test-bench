require_relative '../../test_init'

context "Test" do
  block_executed = false

  return_value = nil

  prose = Controls::Test::Prose.example

  Controls::Evaluate.() do
    return_value = test "#{prose}" do
      block_executed = true

      :other_return_value
    end
  end

  test "Block is executed" do
    assert(block_executed)
  end

  test "Returns true" do
    assert(return_value == true)
  end
end
