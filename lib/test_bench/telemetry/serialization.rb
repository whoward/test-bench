module TestBench
  class Telemetry
    extend InternalLogging

    def self.dump telemetry
      logger.trace "Serializing telemetry (Tests: #{telemetry.tests})"

      hash = telemetry.to_h
      hash[:start_time] = hash[:start_time]&.iso8601 5
      hash[:stop_time] = hash[:stop_time]&.iso8601 5

      data = JSON.generate hash

      logger.debug "Serialized telemetry (Tests: #{telemetry.tests}, Size: #{data.bytesize})"
      logger.data "JSON:"
      logger.data do JSON.pretty_generate hash end

      data
    end

    def self.load data
      logger.trace "Deserializing telemetry (Size: #{data.bytesize})"
      logger.data do "Raw: #{data}" end

      hash = JSON.parse data, :symbolize_names => true

      logger.data "JSON:"
      logger.data do JSON.pretty_generate hash end

      telemetry = new(
        hash.fetch(:files),
        hash.fetch(:passes),
        hash.fetch(:failures),
        hash.fetch(:skips),
        hash.fetch(:assertions),
        Time.parse(hash.fetch(:start_time)),
        Time.parse(hash.fetch(:stop_time)),
      )

      logger.debug "Serialized telemetry (Size: #{data.bytesize}, Tests: #{telemetry.tests})"

      telemetry
    end
  end
end
