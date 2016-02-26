require_relative './test_init'

context "Telemetry" do
  test "Record that a file was executed" do
    telemetry = TestBench::Telemetry.build

    telemetry.file_executed 'some/file.rb'

    assert telemetry.files.include? 'some/file.rb'
  end

  test "Record that a test passed" do
    telemetry = TestBench::Telemetry.build

    telemetry.test_passed

    assert telemetry.passes == 1
  end

  test "Record that a test failed" do
    telemetry = TestBench::Telemetry.build

    telemetry.test_failed

    assert telemetry.failures == 1
  end

  test "Record that a test was skipped" do
    telemetry = TestBench::Telemetry.build

    telemetry.test_skipped

    assert telemetry.skips == 1
  end

  test "Record that an assertion was made" do
    telemetry = TestBench::Telemetry.build

    telemetry.asserted

    assert telemetry.assertions == 1
  end

  context "Calculations" do
    test "Total number of tests" do
      telemetry = TestBench::Telemetry.new

      telemetry.failures = 1
      telemetry.passes = 2
      telemetry.skips = 3

      assert telemetry.tests == 6
    end

    test "Elapsed time" do
      t0 = Controls::Clock::Elapsed.t0
      t1 = Controls::Clock::Elapsed.t1
      elapsed_time = Controls::Clock::Elapsed.seconds

      telemetry = TestBench::Telemetry.build

      telemetry.start_time = t0
      telemetry.stop_time = t1

      assert telemetry.elapsed_time == elapsed_time
    end

    context "Pass/fail results" do
      passed = Controls::Telemetry::Passed.example
      failed = Controls::Telemetry::Failed.example

      test "Passed" do
        assert passed.passed?
        assert !failed.passed?
      end

      test "Failed" do
        assert failed.failed?
        assert !passed.failed?
      end
    end
  end

  context "Serialization" do
    test do
      control_data = Controls::Telemetry.data
      telemetry = Controls::Telemetry.example

      data = TestBench::Telemetry.dump telemetry

      assert data == control_data
    end

    test "Deserialization" do
      data = Controls::Telemetry.data
      control_telemetry = Controls::Telemetry.example

      telemetry = TestBench::Telemetry.load data

      assert telemetry == control_telemetry
    end
  end

  context "Registry" do
    test "The same binding always receives the same telemetry" do
      registry = TestBench::Telemetry::Registry.new
      binding = Controls::Binding.example

      telemetry1 = registry.get binding
      telemetry2 = registry.get binding

      assert telemetry1.object_id == telemetry2.object_id
    end

    test "Different bindings receive different telemetry" do
      registry = TestBench::Telemetry::Registry.new
      binding1 = Controls::Binding.example
      binding2 = Controls::Binding.example

      telemetry1 = registry.get binding1
      telemetry2 = registry.get binding2

      assert telemetry1.object_id != telemetry2.object_id
    end

    test "The same object in a child process receives different telemetry" do
      registry = TestBench::Telemetry::Registry.new
      binding = Controls::Binding.example

      telemetry1 = registry.get binding

      child_pid = fork do
        telemetry2 = registry.get binding
        assert telemetry1.object_id != telemetry2.object_id
      end

      _, status = Process.wait2 child_pid

      assert status.exitstatus == 0
    end
  end

  context "Merging" do
    test do
      control_telemetry = Controls::Telemetry::Merged.example

      telemetry1 = Controls::Telemetry::Merged.first
      telemetry2 = Controls::Telemetry::Merged.second

      telemetry = telemetry1 + telemetry2

      assert telemetry == control_telemetry
    end

    context "Timestamps" do
      t0 = Time.new 2000
      t1 = Time.new 2001
      t2 = Time.new 2002

      test do
        telemetry1 = TestBench::Telemetry.build
        telemetry1.start_time = t0
        telemetry1.stop_time = t1

        telemetry2 = TestBench::Telemetry.build
        telemetry2.start_time = t1
        telemetry2.stop_time = t2

        telemetry = telemetry1 + telemetry2

        assert telemetry.start_time == t0
        assert telemetry.stop_time == t2
      end

      test "Nil values" do
        telemetry1 = TestBench::Telemetry.build
        telemetry1.start_time = t0

        telemetry2 = TestBench::Telemetry.build
        telemetry2.stop_time = t1

        telemetry = telemetry1 + telemetry2

        assert telemetry.start_time == t0
        assert telemetry.stop_time == t1
      end
    end
  end
end
