require_relative '../test_init'

context "Pulling settings from the environment" do
  test "Abort on error" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_ABORT_ON_ERROR' => 'on'

    environment.()

    assert settings.abort_on_error == true
  end

  test "Color" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_COLOR' => 'off'

    environment.()

    assert settings.color == false
  end

  test "Exclude pattern" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_EXCLUDE_PATTERN' => 'some.pattern'

    environment.()

    assert settings.exclude_pattern == 'some.pattern'
  end

  test "Reverse backtraces" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_REVERSE_BACKTRACES' => 'on'

    environment.()

    assert settings.reverse_backtraces == true
  end

  test "Quiet" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_QUIET' => 'on'

    environment.()

    assert settings.writer.level == :quiet
  end

  test "Recording telemetry" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_RECORD_TELEMETRY' => 'on'

    environment.()

    assert settings.record_telemetry == true
  end

  test "Tests directory" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_TESTS_DIR' => '/some/dir'

    environment.()

    assert settings.tests_dir == '/some/dir'
  end

  test "Verbose" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_VERBOSE' => 'on'

    environment.()

    assert settings.writer.level == :verbose
  end

  context "Boolean interpretation" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings

    context "Activated" do
      test "On" do
        assert environment.activated? 'on'
        assert environment.activated? 'On'
        assert environment.activated? 'ON'
      end

      test "Digit 1" do
        assert environment.activated? '1'
      end

      test "Yes" do
        assert environment.activated? 'y'
        assert environment.activated? 'Y'
        assert environment.activated? 'yes'
        assert environment.activated? 'YES'
        assert environment.activated? 'Yes'
      end
    end

    context "Deactivated" do
      test "Off" do
        assert !environment.activated?('off')
        assert !environment.activated?('Off')
        assert !environment.activated?('OFF')
      end

      test "Digit 0" do
        assert !environment.activated?('0')
      end

      test "No" do
        assert !environment.activated?('n')
        assert !environment.activated?('N')
        assert !environment.activated?('no')
        assert !environment.activated?('No')
        assert !environment.activated?('NO')
      end

      test "Not supplied" do
        assert !environment.activated?(nil)
      end
    end

    test "Invalid" do
      begin
        environment.activated? 'not-boolean'
      rescue ArgumentError => error
      end

      assert error
      assert error.message == %{Invalid boolean value "not-boolean"; values that are toggled can be set via "on" or "off", "yes" or "no", "y" or "n", or "0" or "1".}
    end
  end
end
