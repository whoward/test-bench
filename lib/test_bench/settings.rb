module TestBench
  class Settings
    using NullObject::NullAttribute

    attr_writer :child_count
    attr_writer :exclude_pattern
    attr_writer :fail_fast
    attr_writer :output

    def self.build
      instance = new
      instance.output = Output.instance
      instance
    end

    def child_count
      nil_coalesce :@child_count, Defaults.child_count
    end

    def exclude_pattern
      nil_coalesce :@exclude_pattern, Defaults.exclude_pattern
    end

    def fail_fast
      nil_coalesce :@fail_fast, Defaults.fail_fast
    end

    def lower_verbosity
      output.lower_verbosity
    end

    def nil_coalesce ivar, default_value
      if instance_variable_defined? ivar
        instance_variable_get ivar
      else
        instance_variable_set ivar, default_value
      end
    end

    def output
      @output ||= Output.new :normal
    end

    def raise_verbosity
      output.raise_verbosity
    end

    def self.toplevel
      Registry.get TOPLEVEL_BINDING
    end
  end
end
