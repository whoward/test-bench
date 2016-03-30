require_relative './test_init'

context "Expanding a path into a set of files" do
  dir = Controls::DirSubstitute.example
  root_directory = Controls::ExpandPath::RootDirectory.example
  control_files = %w(/root/some/path/1.rb /root/some/path/2.rb /root/other/path.rb)

  test "Directories" do
    expand_path = TestBench::ExpandPath.build root_directory, :dir => dir

    files = expand_path.('./')

    assert files == control_files
  end

  test "Glob patterns" do
    expand_path = TestBench::ExpandPath.build root_directory, :dir => dir

    files = expand_path.('**/*.rb')

    assert files == control_files
  end

  context "Exclude pattern" do
    control_files = %w(/root/some/path/1.rb /root/some/path/2.rb)

    test do
      expand_path = TestBench::ExpandPath.build(
        root_directory,
        %r{other\/path\.rb$},
        :dir => dir,
      )

      files = expand_path.('**/*.rb')

      assert files == control_files
    end

    test "Pattern can also be supplied as a string" do
      expand_path = TestBench::ExpandPath.build(
        root_directory,
        "other/path.rb$",
        :dir => dir,
      )

      files = expand_path.('**/*.rb')

      assert files == control_files
    end
  end
end
