require 'semlogr/rack/request_logger'

module Semlogr
  module Rack
    describe RequestLogger do
      describe '#call' do
        let(:env) { { 'REQUEST_METHOD' => 'GET', 'REQUEST_URI' => '/foo' } }
        let(:status) { 200 }
        let(:headers) { {} }
        let(:body) { 'foo' }
        let(:app) { spy('app') }
        let(:logger) { spy('logger') }
        let(:path_filters) { [] }

        subject { RequestLogger.new(app, logger: logger, path_filters: path_filters) }

        it 'logs request info with time to call nested middleware' do
          allow(app).to receive(:call)
            .with(env) { sleep(1) }
            .and_return([status, headers, body])

          subject.call(env)

          expect(logger).to have_received(:info)
            .with(
              'HTTP {method} {path} - {status} ({duration}s)',
              hash_including(
                method: env['REQUEST_METHOD'],
                path: env['REQUEST_URI'],
                status: status,
                duration: be_within(0.01).of(1)
              )
            )
        end

        it 'returns result from wrapped middleware' do
          allow(app).to receive(:call)
            .with(env)
            .and_return([status, headers, body])

          s, h, b = subject.call(env)

          expect(s).to eq(status)
          expect(h).to eq(headers)
          expect(b).to eq(body)
        end

        context 'with filter added' do
          let(:path_filters) { [%r{^/foo}] }

          it 'does not log request' do
            subject.call(env)

            expect(logger).to_not have_received(:info)
          end
        end
      end
    end
  end
end
