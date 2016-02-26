module TestBench
  class Assert
    include InternalLogging

    attr_reader :block
    attr_reader :mod
    attr_reader :subject

    def initialize subject, mod, block
      @subject = subject
      @mod = mod
      @block = block
    end

    def self.call subject, mod=nil, &block
      block ||= identity_block

      instance = new subject, mod, block
      instance.call
    end

    def assertions_module
      return mod if mod

      if subject_namespace.const_defined? :Assertions
        subject_namespace.const_get :Assertions
      end
    end

    def call
      logger.trace "Asserting (Subject Type: #{subject_namespace.to_s.inspect})"

      extend_subject assertions_module if assertions_module

      result = subject.instance_exec subject, &block
      passed = if result then true else false end

      logger.debug "Asserted (Subject Type: #{subject_namespace.to_s.inspect}, Passed: #{passed})"

      passed
    end

    def extend_subject mod
      logger.trace "Extending subject (Module: #{mod.name.inspect})"

      raise TypeError if subject.frozen?
      subject.extend mod

      logger.debug "Extended subject (Module: #{mod.name.inspect})"

    rescue TypeError
      logger.debug "Did not extend subject; is subject frozer, or missing singleton class? (Module: #{mod.name.inspect}, Subject Type: #{subject_namespace.inspect})"
    end

    def subject_namespace
      if subject.is_a? Module
        subject
      else
        subject.class
      end
    end

    def self.identity_block
      @identity_block ||= -> subject do subject end
    end
  end
end
