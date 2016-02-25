module TestBench
  module Controls
    module Path
      def self.example filename=nil
        filename ||= 'file.rb'

        "some/#{filename}"
      end
    end
  end
end
