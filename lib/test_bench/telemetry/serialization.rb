module TestBench
  class Telemetry
    def self.dump telemetry
      hash = telemetry.to_h
      hash[:start_time] = hash[:start_time]&.iso8601 5
      hash[:stop_time] = hash[:stop_time]&.iso8601 5

      JSON.generate hash
    end

    def self.load data
      hash = JSON.parse data, :symbolize_names => true

      new(
        hash.fetch(:files),
        hash.fetch(:passes),
        hash.fetch(:failures),
        hash.fetch(:skips),
        hash.fetch(:assertions),
        hash.fetch(:errors),
        Time.parse(hash.fetch(:start_time)),
        Time.parse(hash.fetch(:stop_time)),
      )
    end
  end
end
