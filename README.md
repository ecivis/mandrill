# Mandrill

[![Master Branch Build Status](https://img.shields.io/travis/ecivis/mandrill/master.svg?style=flat-square&label=master)](https://travis-ci.org/ecivis/mandrill)


This is a ColdBox Module to use with the Mandrill API. See the [Mandrill API Documentation](https://mandrillapp.com/api/docs/) for more information about the service.

## Requirements
- Lucee 5.2+
- ColdBox 4.3+
- Java 8+

## Installation

Install using [CommandBox](https://www.ortussolutions.com/products/commandbox):
`box install mandrill`

Within `config/Coldbox.cfc` add a module settings element named `mandrill` and define your Mandrill API key in `apiKey`. Optionally, the default endpoint base URL (https://mandrillapp.com/api/1.0/) may be overridden using `endpointBaseUrl`:
```
moduleSettings = {
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
getInstance("mandrillClient@mandrill").messages.send(message=message);
```

It's important to note that the sender address for messages sent through Mandrill must match a verified domain. See the [knowledge base article](https://mandrill.zendesk.com/hc/en-us/articles/205582247-About-Domain-Verification) on this topic for more information.

### Support

This project is an attempt to mimic the official Mandrill libraries for Python and Node.js. All of the features of the Mandrill API aren't implemented yet. Here's a summary of the calls supported in this version:

[/users/info](https://mandrillapp.com/api/docs/users.JSON.html#method=info)
`Mandrill.users.info()`

[/messages/send](https://mandrillapp.com/api/docs/messages.JSON.html#method=send)
`Mandrill.messages.send(required struct message, boolean async, string ip_pool, string send_at)`

[/messages/send-template](https://mandrillapp.com/api/docs/messages.JSON.html#method=send-template)
`Mandrill.messages.send_template(required string template_name, required array template_content, required struct message, boolean async, string ip_pool, string send_at)`

[/rejects/list](https://mandrillapp.com/api/docs/rejects.JSON.html#method=list)
`Mandrill.rejects.list(string email, boolean include_expired, string subaccount)`

[/rejects/add](https://mandrillapp.com/api/docs/rejects.JSON.html#method=add)
`Mandrill.rejects.add(required string email, string comment, string subaccount)`

[/rejects/delete](https://mandrillapp.com/api/docs/rejects.JSON.html#method=delete)
`Mandrill.rejects.delete(required string email, string subaccount)`

[/whitelists/list](https://mandrillapp.com/api/docs/whitelists.JSON.html#method=list)
`Mandrill.whitelists.list(string email)`

[/whitelists/add](https://mandrillapp.com/api/docs/whitelists.JSON.html#method=add)
`Mandrill.whitelists.add(required string email, string comment)`

[/whitelists/delete](https://mandrillapp.com/api/docs/whitelists.JSON.html#method=delete)
`Mandrill.whitelists.delete(required string email)`


## Tests

The package is configured such that tests can be executed within CommandCox using `testbox run`. Note that environment variables `SERVER_HOST` and `SERVER_PORT` can be set to configure the CFML engine used for testing.

By default, the REST calls to Mandrill are mocked. To run the tests against the live Mandrill service, define a valid Mandrill API key as an environment variable (`MANDRILL_API_KEY`) or a Java system property (`mandrill.api.key`). Also ensure that `authDomain` in the test spec configuration is verified and matches the API key.

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
