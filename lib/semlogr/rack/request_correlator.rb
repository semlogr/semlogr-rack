require 'semlogr'
require 'securerandom'

module Semlogr
  module Rack
    class RequestCorrelator
      def initialize(app, opts = {})
        @app = app
        @id_header = opts[:id_header] || 'X-Correlation-Id'
        @id_generator = opts[:id_generator] || -> { SecureRandom.uuid }
      end

      def call(env)
        id_header = env_header_name(@id_header)
        correlation_id = env[id_header] || @id_generator.call
        status, headers, body =
          Semlogr::LogContext.push_property(correlation_id: correlation_id) do
            @app.call(env)
          end

        headers[@id_header] = correlation_id

        [status, headers, body]
      end

      private

      def env_header_name(header)
        'HTTP_' + header.tr('-', '_').upcase
      end
    end
  end
end
