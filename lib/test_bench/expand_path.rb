module TestBench
  class ExpandPath
    attr_reader :dir
    attr_reader :root_directory

    def initialize root_directory, dir
      @dir = dir
      @root_directory = root_directory
    end

    def self.build root_directory
      dir = Dir

      root_directory = Pathname(root_directory)

      instance = new root_directory, dir
      instance
    end

    def call pattern
      full_pattern = root_directory.join pattern

      if full_pattern.directory?
        full_pattern = full_pattern.join '**/*.rb'
      end

      dir[full_pattern.to_s].map do |file|
        pathname = Pathname.new file
        pathname = pathname.relative_path_from root_directory
        pathname.to_s
      end
    end
  end
end
