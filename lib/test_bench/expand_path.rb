module TestBench
  class ExpandPath
    attr_reader :dir
    attr_writer :exclude_pattern
    attr_reader :root_directory

    def initialize root_directory, dir
      @dir = dir
      @root_directory = root_directory
    end

    def self.build root_directory, exclude_pattern=nil
      exclude_pattern ||= Settings.toplevel.exclude_pattern

      dir = Dir

      root_directory = Pathname(root_directory)

      instance = new root_directory, dir
      instance.exclude_pattern = exclude_pattern
      instance
    end

    def call pattern
      full_pattern = root_directory.join pattern

      if full_pattern.directory?
        full_pattern = full_pattern.join '**/*.rb'
      end

      expand full_pattern.to_s
    end

    def exclude_pattern
      @exclude_pattern ||= /^$/
    end

    def expand full_pattern
      dir[full_pattern].flat_map do |file|
        pathname = Pathname.new file
        pathname = pathname.relative_path_from root_directory

        path = pathname.to_s

        if exclude_pattern.match path then [] else [path] end
      end
    end
  end
end
