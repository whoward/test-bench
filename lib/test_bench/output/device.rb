module TestBench
  module Output
    module Device
      def self.configure(receiver, device: nil, attr_name: nil)
        attr_name ||= :device
        device ||= Defaults.device

        receiver.public_send("#{attr_name}=", device)

        device
      end

      module Defaults
        def self.device
          $stdout
        end
      end

      module Dependency
        attr_writer :device
        def device
          @device ||= StringIO.new
        end
      end
    end
  end
end
