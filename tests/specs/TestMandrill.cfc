component extends="testbox.system.BaseSpec" {

    public function run() {

        variables.config = {
            "apiKey": getApiKey(),
            "authDomain": "domain.tld"
        };
        if (variables.config.apiKey.len()) {
            variables.config.liveTest = true;
        }

        // Force non-live tests, even when the API key exists
        variables.config.liveTest = false;

        describe("The Mandrill client", function () {

            beforeEach(function () {
                if (variables.config.liveTest) {
                    variables.mandrillConnector = new mandrill.models.MandrillConnector(apiKey=getApiKey());
                } else {
                    variables.mandrillConnector = getMockBox().createEmptyMock("mandrill.models.MandrillConnector");
                }
            });


            /* USERS */

            it("should get user information", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var result = {};

                if (!variables.config.liveTest) {
                    variables.mandrillConnector.$(method="makeApiCall", returns={"username":"__1234567890__", "stats":{"today":{"sent":11}}});
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.users.info();

                debug(result);

                expect(result.keyExists("username")).toBeTrue();
                expect(result.keyExists("stats")).toBeTrue();
            });


            /* MESSAGES */

            it("should be able to send a basic message", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var message = {};
                var result = {};
                var response = [];

                if (!variables.config.liveTest) {
                    response = [
                        {
                            "status": "sent",
                            "email": "recipient@domain.tld"
                        }
                    ];
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                message = {
                    "html": "<p>This is a test email.</p>",
                    "subject": "Test Email",
                    "from_email": "sender@#variables.config.authDomain#",
                    "from_name": "Test Sender",
                    "to": [
                        {
                            "email": "recipient@domain.tld",
                            "name": "Test Recipient"
                        }
                    ]
                };

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.messages.send(message=message);

                debug(result);

                expect(result.len()).toBe(1);
                expect(result[1].status).toBe("sent");
                expect(result[1].email).toBe("recipient@domain.tld");
            });

            it("should be able to send a message using a template", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var template_content = [];
                var message = {};
                var result = {};
                var response = [];

                if (!variables.config.liveTest) {
                    response = [
                        {
                            "status": "sent",
                            "email": "recipient@domain.tld"
                        }
                    ];
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                template_content.append({"name":"header_text", "content":"Test Message Header"});
                template_content.append({"name":"body_text", "content":"<p>This is a test message.</p>"});

                message = {
                    "subject": "Test Email",
                    "from_email": "sender@#variables.config.authDomain#",
                    "from_name": "Test Sender",
                    "to": [
                        {
                            "email": "recipient@domain.tld",
                            "name": "Test Recipient"
                        }
                    ]
                };

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.messages.send_template(template_name="generic-email-template", template_content=template_content, message=message, async=false);

                debug(result);

                expect(result.len()).toBe(1);
                expect(result[1].status).toBe("sent");
                expect(result[1].email).toBe("recipient@domain.tld");
            });


            /* REJECTS */

            it("should get a list of rejects with stats", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var response = [];
                var result = {};

                if (!variables.config.liveTest) {
                    response = [
                        {
                            "email": "hard-bounce@domain.tld",
                            "reason": "hard-bounce",
                            "detail": "550 mailbox does not exist",
                            "expired": false,
                            "sender": {
                                "address": "sender@#variables.config.authDomain#",
                                "rejects": 4
                            }
                        }
                    ];
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.rejects.list(include_expired=false);

                debug(result);

                if (!variables.config.liveTest) {
                    expect(result[1].email).toBe("hard-bounce@domain.tld");
                }
            });

            it("should be able to add a rejected address", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var response = [];
                var result = {};

                if (!variables.config.liveTest) {
                    response = {
                        "email": "rejected@domain.tld",
                        "added": true
                    };
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.rejects.add(email="rejected@domain.tld");

                debug(result);
            });

            it("should be able to delete a rejected address", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var response = [];
                var result = {};

                if (!variables.config.liveTest) {
                    response = {
                        "email": "rejected@domain.tld",
                        "deleted": true
                    };
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.rejects.delete(email="rejected@domain.tld");

                debug(result);
            });


            /* WHITELISTS */

            it("should get a list of whitelisted addresses", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var response = [];
                var result = {};

                if (!variables.config.liveTest) {
                    response = [
                        {
                            "email": "whitelisted@domain.tld",
                            "detail": "Whitelisted address"
                        }
                    ];
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.whitelists.list();

                debug(result);

                if (!variables.config.liveTest) {
                    expect(result[1].email).toBe("whitelisted@domain.tld");
                }
            });

            it("should be able to add a whitelisted address", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var response = [];
                var result = {};

                if (!variables.config.liveTest) {
                    response = {
                        "email": "whitelisted@domain.tld",
                        "added": true
                    };
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.whitelists.add(email="whitelisted@domain.tld");

                debug(result);
            });

            it("should be able to delete a whitelisted address", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var response = [];
                var result = {};

                if (!variables.config.liveTest) {
                    response = {
                        "email": "whitelisted@domain.tld",
                        "deleted": true
                    };
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.whitelists.delete(email="whitelisted@domain.tld");

                debug(result);
            });

        });
    };


    private string function getApiKey() {
        var apiKey = "";

        apiKey = createObject("java", "System").getenv("MANDRILL_API_KEY");
        if (!isNull(apiKey) && apiKey.len()) {
            return apiKey;
        }
        apiKey = createObject("java", "System").getProperty("mandrill.api.key");
        if (!isNull(apiKey) && apiKey.len()) {
            return apiKey;
        }
        return "";
    }

}