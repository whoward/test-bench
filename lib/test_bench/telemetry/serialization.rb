module TestBench
  class Telemetry
    extend InternalLogging

    def self.dump telemetry
      logger.debug "Serializing telemetry (Tests: #{telemetry.tests})"

      hash = telemetry.to_h
      hash[:start_time] = hash[:start_time]&.iso8601 5
      hash[:stop_time] = hash[:stop_time]&.iso8601 5

      data = JSON.generate hash

      logger.info "Serialized telemetry (Tests: #{telemetry.tests}, Size: #{data.bytesize})"
      logger.debug "JSON:"
      logger.debug do JSON.pretty_generate hash end

      data
    end

    def self.load data
      logger.debug "Deserializing telemetry (Size: #{data.bytesize})"
      logger.debug do "Raw: #{data}" end

      hash = JSON.parse data, :symbolize_names => true

      logger.debug "JSON:"
      logger.debug do JSON.pretty_generate hash end

      telemetry = new(
        hash.fetch(:files),
        hash.fetch(:passes),
        hash.fetch(:failures),
        hash.fetch(:skips),
        hash.fetch(:assertions),
        hash.fetch(:errors),
        Time.parse(hash.fetch(:start_time)),
        Time.parse(hash.fetch(:stop_time)),
      )

      logger.info "Serialized telemetry (Size: #{data.bytesize}, Tests: #{telemetry.tests})"

      telemetry
    end
  end
end
