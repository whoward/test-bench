require_relative './test_init'

context "Settings" do
  context "Bootstrap" do
    test do
      settings = TestBench::Settings.new

      settings.bootstrap = true

      assert settings.bootstrap == true
    end

    test "Default is not activated" do
      settings = TestBench::Settings.new

      assert settings.bootstrap == false
    end
  end

  context "Child count" do
    test do
      settings = TestBench::Settings.new

      settings.child_count = 2

      assert settings.child_count == 2
    end

    test "Default is 1" do
      settings = TestBench::Settings.new

      assert settings.child_count == 1
    end
  end

  context "Exclude pattern" do
    test do
      settings = TestBench::Settings.new

      settings.exclude_pattern = 'some-pattern'

      assert settings.exclude_pattern == 'some-pattern'
    end

    test "Default is files ending with \"_init.rb\"" do
      settings = TestBench::Settings.new

      assert settings.exclude_pattern == "_init\\.rb$"
    end
  end

  context "Fail fast" do
    test do
      settings = TestBench::Settings.new

      settings.fail_fast = true

      assert settings.fail_fast == true
    end

    test "Default is not activated" do
      settings = TestBench::Settings.new

      assert settings.fail_fast == false
    end
  end

  test "Hash representation" do
    settings = TestBench::Settings.new

    hash = settings.to_h

    assert hash[:bootstrap] == settings.bootstrap
    assert hash[:child_count] == settings.child_count
    assert hash[:exclude_pattern] == settings.exclude_pattern
    assert hash[:fail_fast] == settings.fail_fast
  end
end
