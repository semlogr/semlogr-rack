module Semlogr
  module Rack
    class RequestLogger
      def initialize(app, logger: nil, path_filters: [])
        @app = app
        @logger = logger
        @path_filters = path_filters
      end

      def call(env)
        path = env['REQUEST_URI']
        return @app.call(env) if filtered?(path)

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        status, headers, body = @app.call(env)
        finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        logger.info(
          'HTTP {method} {path} - {status} ({duration}s)',
          method: env['REQUEST_METHOD'],
          path: path,
          status: status,
          duration: (finish - start).round(4)
        )

        [status, headers, body]
      end

      private

      def logger
        @logger || Semlogr.logger
      end

      def filtered?(path)
        @path_filters.any? { |filter| filter =~ path }
      end
    end
  end
end
