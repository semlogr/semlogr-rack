require 'semlogr'
require 'semlogr/rack/request_correlator'

module Semlogr
  module Rack
    describe RequestCorrelator do
      let(:env_without_id) { {} }
      let(:env_with_id) { { 'HTTP_X_CORRELATION_ID' => '1234' } }
      let(:app) { spy('app') }
      let(:id_generator) { spy('id_generator') }

      subject { RequestCorrelator.new(app, id_generator: id_generator) }

      before do
        allow(app)
          .to receive(:call)
          .and_return([200, {}, 'Hello'])

        allow(Semlogr::Context::LogContext)
          .to receive(:push_property)
          .and_yield
      end

      context 'with x-correlation-id-header' do
        let(:correlation_id) { env_with_id['HTTP_X_CORRELATION_ID'] }

        it 'adds existing correlation-id to the log context' do
          subject.call(env_with_id)

          expect(Semlogr::Context::LogContext)
            .to have_received(:push_property)
            .with(correlation_id: correlation_id)
        end

        it 'adds correlation-id to response headers' do
          _status, headers, _body = subject.call(env_with_id)

          expect(headers['X-Correlation-Id']).to eq(correlation_id)
        end
      end

      context 'without x-correlation-id header' do
        let(:correlation_id) { '4321' }

        before do
          allow(id_generator)
            .to receive(:call)
            .and_return(correlation_id)
        end

        it 'adds new correaltion-id to the log context' do
          subject.call(env_without_id)

          expect(Semlogr::Context::LogContext)
            .to have_received(:push_property)
            .with(correlation_id: correlation_id)
        end

        it 'adds correlation-id to response headers' do
          _status, headers, _body = subject.call(env_without_id)

          expect(headers['X-Correlation-Id']).to eq(correlation_id)
        end
      end
    end
  end
end
