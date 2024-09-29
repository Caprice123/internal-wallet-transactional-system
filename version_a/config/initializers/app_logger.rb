class AppLogger
  # To add a new tag, add in TAG array

  class << self
    TAGS = %i[
      traffic
      integration
    ].freeze

    def memoize_results(key)
      return instance_variable_get(key) if instance_variable_defined?(key)
      instance_variable_set key, yield
    end

    TAGS.each do |tag|
      define_method(tag) do
        tag_name = tag.to_s
        memoize_results("@#{tag_name}") do
          configure_logger(tag_name)
        end
      end
    end

    def configure_logger(tag)
      logger = Logger.new(Rails.root.join("log", "#{tag}.log"))
      logger.extend(ActiveSupport::Logger.broadcast(Logger.new(STDOUT))) unless Rails.env.test?
      logger.formatter = formatter_for_concern(tag)
      logger.level = Rails.logger.level
      logger
    end

    def formatter_for_concern(tag)
      proc do |severity, datetime, _progname, msg|
        string_message = if msg.is_a?(String)
                           msg
                         elsif msg.is_a?(Hash)
                           clean_msg = traverse_and_encode(msg)
                           clean_msg.to_json
                         else
                           raise "Check log format"
                         end
        "[#{tag}] " \
          "[#{datetime.to_fs(:db)}] " \
          "[id.#{Rails.env}] " \
          "[#{severity[0]}] " \
          "#{string_message}\n"
      rescue StandardError
      end
    end

    def traverse_and_encode(params)
      case params
      when Hash
        params.map { |k, v| [traverse_and_encode(k), traverse_and_encode(v)] }.to_h
      when Array
        params.map { |i| traverse_and_encode(i) }
      when Numeric
        params
      when String
        params.dup.force_encoding("ISO-8859-1").encode("UTF-8")
      else
        traverse_and_encode(params.to_s)
      end
    end
  end
end
