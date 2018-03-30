module Semlogr
  module Rack
    class RequestLogger
      def initialize(app, logger = nil)
        @app = app
        @logger = logger
      end

      def call(env)
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        status, headers, body = @app.call(env)
        finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        logger.info(
          'HTTP {method} {path} - {status} ({duration}s)',
          method: env['REQUEST_METHOD'],
          path: env['REQUEST_URI'],
          status: status,
          duration: (finish - start).round(4)
        )

        [status, headers, body]
      end

      private

      def logger
        @logger || Semlogr.logger
      end
    end
  end
end
