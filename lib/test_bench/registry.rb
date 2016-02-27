module TestBench
  class Registry
    attr_reader :cls

    def initialize cls
      @cls = cls
    end

    def key binding
      "#{binding.receiver.object_id}-#{Process.pid}"
    end

    def get binding
      key = self.key binding
      table[key]
    end

    def table
      @table ||= Hash.new do |hash, key|
        hash[key] = cls.build
      end
    end

    def self.instance
      @instance ||= new
    end

    def self.get binding
      instance.get binding
    end
  end
end
