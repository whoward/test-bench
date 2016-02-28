require_relative './test_init'

context "Settings" do
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

  context "Adjusting verbosity" do
    test "Raising" do
      settings = TestBench::Settings.new

      settings.raise_verbosity

      assert settings.output.level == :verbose
    end

    test "Lowering" do
      settings = TestBench::Settings.new

      settings.lower_verbosity

      assert settings.output.level == :quiet
    end
  end
end
