module TestBench
  class Settings
    attr_writer :bootstrap
    attr_writer :child_count
    attr_writer :exclude_pattern
    attr_writer :fail_fast
    attr_writer :internal_log_level

    def self.build
      instance = new
      Environment.(instance)
      instance
    end

    def bootstrap
      nil_coalesce :@bootstrap, Defaults.bootstrap
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

    def internal_log_level
      nil_coalesce :@internal_log_level, Defaults.internal_log_level
    end

    def nil_coalesce ivar, default_value
      if instance_variable_defined? ivar
        instance_variable_get ivar
      else
        instance_variable_set ivar, default_value
      end
    end

    def to_h
      {
        :bootstrap => bootstrap,
        :child_count => child_count,
        :exclude_pattern => exclude_pattern,
        :internal_log_level => internal_log_level,
        :fail_fast => fail_fast,
      }
    end

    def self.configure receiver
      receiver.settings = self.instance
    end

    def self.instance
      @instance ||= build
    end
  end
end
