require_relative './test_init'

context "Expanding a path into a set of files" do
  test do
    dir = Controls::DirSubstitute.example
    root_directory = Controls::ExpandPath::RootDirectory.example

    expand_path = TestBench::ExpandPath.new root_directory, dir

    files = expand_path.('**/*.rb')

    assert files == %w(
      /root/some/path/1.rb
      /root/some/path/2.rb
      /root/other/path.rb
    )
  end

  test "Exclude pattern" do
    dir = Controls::DirSubstitute.example
    root_directory = Controls::ExpandPath::RootDirectory.example

    expand_path = TestBench::ExpandPath.new root_directory, dir
    expand_path.exclude_pattern = /other\/path\.rb$/

    files = expand_path.('**/*.rb')

    assert files == %w(/root/some/path/1.rb /root/some/path/2.rb)
  end
end
