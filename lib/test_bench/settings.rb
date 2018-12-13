module TestBench
  class Settings
    Error = Class.new(RuntimeError)

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def self.build(env=nil)
      data = Data.get(env)

      new(data)
    end

    def self.instance
      @instance ||= build
    end

    def self.get(setting)
      instance.get(setting)
    end

    def self.setting_names
      [:abort_on_error, :backtrace_filter, :color, :exclude_pattern, :reverse_backtraces, :silent]
    end

    def set(receiver)
      self.class.setting_names.each do |setting|
        setter = "#{setting}="

        next unless receiver.respond_to?(setter)

        value = data[setting]

        receiver.public_send(setter, value)
      end
    end

    self.setting_names.each do |setting|
      define_method(setting) do
        data[setting]
      end

      define_method("#{setting}=") do |value|
        data[setting] = value
      end
    end
  end
end
