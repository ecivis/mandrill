# Mandrill

This is a ColdBox Module to use with the Mandrill API. See the [Mandrill API Documentation](https://mandrillapp.com/api/docs/) for more information about the service.

See `tests.specs.TestMandrill` for example usage. Better documentation, a more complete implementation, and configuration guidance will be added as the project matures.

## Requirements
- Lucee 5+
- ColdBox 4+
- Java 8+

## Installation

Install using [CommandBox](https://www.ortussolutions.com/products/commandbox):
`box install mandrill`

Create an application-specific mapping for `/modules/mandrill/models` as `/mandrill`.

## Tests

The package is configured such that tests can be executed within CommandCox using `testbox run`. Note that environment variables `SERVER_HOST` and `SERVER_PORT` can be set to configure the CFML engine used for testing.

By default, the REST calls to Mandrill are mocked. To run the tests against the live Mandrill service, define a valid Mandrill API key as an environment variable (`MANDRILL_API_KEY`) or a Java system property (`mandrill.api.key`). Also ensure that `authDomain` in the test spec configuration is verified and matches the API key.

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
