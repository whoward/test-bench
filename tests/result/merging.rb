require_relative '../test_init'

context "Merging results" do
  test do
    control_result = Controls::Result::Merged.example

    result1 = Controls::Result::Merged.first
    result2 = Controls::Result::Merged.second
    result3 = Controls::Result::Merged.third

    result = result1 + result2 + result3

    assert result == control_result
  end

  context "Timestamps" do
    t0 = Time.new 2000
    t1 = Time.new 2001
    t2 = Time.new 2002

    test do
      result1 = TestBench::Result.build
      result1.start_time = t0
      result1.stop_time = t1

      result2 = TestBench::Result.build
      result2.start_time = t1
      result2.stop_time = t2

      result = result1 + result2

      assert result.start_time == t0
      assert result.stop_time == t2
    end

    test "Nil values" do
      result1 = TestBench::Result.build
      result1.start_time = t0

      result2 = TestBench::Result.build
      result2.stop_time = t1

      result = result1 + result2

      assert result.start_time == t0
      assert result.stop_time == t1
    end
  end
end
