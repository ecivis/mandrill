# Mandrill

This is a ColdBox Module to use with the Mandrill API. See the [Mandrill API Documentation](https://mandrillapp.com/api/docs/) for more information about the service.

## Requirements
- Lucee 5+
- ColdBox 4+
- Java 8+

## Installation

Install using [CommandBox](https://www.ortussolutions.com/products/commandbox):
`box install mandrill`

Create an application-specific mapping for `/modules/mandrill/models` as `/mandrill`.

Add a ColdBox setting named mandrill, containing a valid API key as `apiKey`. Optionally, the default endpoint base URL (https://mandrillapp.com/api/1.0/) may be overridden using `endpointBaseUrl`:
```
    settings = {
        "mandrill" = {
            "apiKey" = "YOUR_API_KEY"
        }
    };

```

## Usage

The Mandrill client will be instantiated and configured on ColdBox application startup. Inject it where needed, or request it by name. Here's how one might send a message from a ColdBox Handler:
```
var message = {
    "html": "<h1>Way To Go Donny!</h1><p>If you will it, Dude, it is no dream.</p>",
    "subject": "Over The Line",
    "from_email": "walter@domain.tld",
    "from_name": "Walter Sobchak",
    "to": [
        {
            "email": "donny@domain.tld",
            "name": "Theodore Donald 'Donny' Kerabatsos"
        },
        {
            "email": "the_dude@domain.tld",
            "name": "The Dude"
        }
    ]
};
getInstance("mandrillClient").messages.send(message=message);
```

It's important to note that the sender address for messages sent through Mandrill must match a verified domain. See the [knowledge base article](https://mandrill.zendesk.com/hc/en-us/articles/205582247-About-Domain-Verification) on this topic for more information.


## Tests

The package is configured such that tests can be executed within CommandCox using `testbox run`. Note that environment variables `SERVER_HOST` and `SERVER_PORT` can be set to configure the CFML engine used for testing.

By default, the REST calls to Mandrill are mocked. To run the tests against the live Mandrill service, define a valid Mandrill API key as an environment variable (`MANDRILL_API_KEY`) or a Java system property (`mandrill.api.key`). Also ensure that `authDomain` in the test spec configuration is verified and matches the API key.

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
