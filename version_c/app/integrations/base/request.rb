module Base
  class Request
    class << self
      def start_faking!(faking_method)
        raise ArgumentError, "Faking method should not be nil" if faking_method.nil?
        @faking_method_stack ||= []
        original_stack = @faking_method_stack.dup

        if block_given?
          @faking_method_stack = [faking_method]
          result = yield

          # Restore to original stack
          @faking_method_stack = original_stack

          result
        else
          @faking_method_stack << faking_method
        end
      end

      def stop_faking!
        @faking_method_stack ||= []
        original_stack = @faking_method_stack.dup

        if block_given?
          @faking_method_stack = [nil]
          result = yield

          # Restore to original stack
          @faking_method_stack = original_stack

          result
        else
          @faking_method_stack << nil
        end
      end

      def current_faking_method
        @faking_method_stack&.last
      end

      # Fake responses storage
      private def fake_responses
        @fake_responses ||= HashWithIndifferentAccess.new
      end

      def define_response_class(&)
        @response_class = Class.new(Base::Response, &)
      end

      def response_class
        @response_class ||= Base::Response
      end

      def add_fake_response(name, &block)
        fake_responses[name] = block
      end

      def fake_response(name)
        fake_responses.fetch(name)
      end
    end

    def base_url
      raise NotImplementedError
    end

    def relative_url
      raise NotImplementedError
    end

    def url
      base = base_url.end_with?("/") ? base_url : "#{base_url}/"
      @url ||= "#{base}#{relative_url}"
    end

    def api_method
      raise NotImplementedError
    end

    def body; end

    def headers; end

    def query; end

    def fire!
      if self.class.current_faking_method.present?
        fake_api_hit!(self.class.current_faking_method)
      else
        real_api_hit!
      end
    end

    private def fake_api_hit!(faking_method)
      raise "Method should not be called in production environment" if Rails.env.production?

      response = self.class.fake_response(faking_method).call(self)
      raise "Please ensure the fake response using the #{self.class}.response_class" unless response.is_a?(self.class.response_class)

      response
    end

    private def timeout_time
      30
    end

    private def real_api_hit!
      response = HTTParty.send(
        api_method.to_sym,
        url,
        headers: headers,
        body: body,
        query: query,
        timeout: timeout_time,
      )
      self.class.response_class.new(response)
    end
  end
end
