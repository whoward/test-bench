module TestBench
  def self.activate receiver=nil
    receiver ||= TOPLEVEL_BINDING.receiver

    receiver.extend TestBench.mod
  end

  def self.mod
    if Settings.instance.bootstrap
      require 'test_bench/bootstrap'
      TestBench::Bootstrap
    else
      self
    end
  end

  def self.runner
    mod.const_get :Runner
  end

  def assert subject=nil, mod=nil, &block
    telemetry = Telemetry::Registry.get binding

    telemetry.asserted
  end

  def context prose=nil, &block
    block.()
  end
end
