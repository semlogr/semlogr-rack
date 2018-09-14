# Changelog

### 0.1.3 - 2018-08-17

- Upgrade semlogr for new flatter LogContext

### 0.1.2 - 2018-04-03

- Change request logger to log only path without query string

### 0.1.1 - 2018-04-03

- Add support for filtering requests by path for the request logger
- Add log correlator middleware which provides the ability to propogate a correlation id from a request header to the Semlogr ambient log context

### 0.1.0 - 2018-03-30

- Initial release
