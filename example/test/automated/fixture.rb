require_relative './automated_init'

module FixtureExample
  class SomeFixture
    include TestBench::Fixture

    def self.call
      instance = new
      TestBench::Telemetry.configure(instance)
      instance.()
    end

    def call
      context "Some Fixture Context" do
        test "Some fixture test" do
          comment "SomeFixture executed"
        end
      end
    end
  end
end

context "Fixture" do
  FixtureExample::SomeFixture.()
end
