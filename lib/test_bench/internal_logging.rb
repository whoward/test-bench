module TestBench
  module InternalLogging
    def self.get receiver
      logger = Logger.new $stdout

      if receiver.is_a? Module
        logger.progname = receiver.name
      else
        logger.progname = receiver.class.name
      end

      logger.level = Settings.instance.internal_log_level
      logger
    end

    def logger
      @logger ||= InternalLogging.get self
    end
  end
end
