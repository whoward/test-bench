module TestBench
  color_scheme = ExtendedLogger::ColorScheme.build(
    :event => :gray,
    :data => :blue,
    :trace => :magenta,
    :debug => :cyan,
    :warn => :brown,
    :error => :red,
    :fatal => { :fg => :white, :bg => :red },
  )

  levels = ExtendedLogger::Level::Set.build(
    %i(event data trace debug info warn error fatal),
    :default => :debug,
  )

  format = -> message do
    time = message.time.iso8601 3
    "[#{time}] #{message.label} (#{message.level}): #{message.prose}"
  end

  logger_class = ExtendedLogger.define(
    levels,
    :color_scheme => color_scheme,
    :format => format,
  )

  InternalLogging = ExtendedLogger::Registry.build logger_class, :device => $stdout

  InternalLogging.level = Settings.instance.internal_log_level
end
