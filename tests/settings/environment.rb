require_relative '../test_init'

context "Pulling settings from the environment" do
  test "Bootstrap" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_BOOTSTRAP' => 'on'

    environment.()

    assert settings.bootstrap == true
  end

  test "Child count" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_CHILD_COUNT' => '2'

    environment.()

    assert settings.child_count == 2
  end

  test "Fail fast" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_FAIL_FAST' => 'on'

    environment.()

    assert settings.fail_fast == true
  end

  test "Internal log level" do
    settings = TestBench::Settings.new
    environment = TestBench::Settings::Environment.build settings,
      'TEST_BENCH_INTERNAL_LOG_LEVEL' => 'some-level'

    environment.()

    assert settings.internal_log_level == 'some-level'
  end

  context "Boolean interpretation" do
    settings = TestBench::NullObject.new
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
