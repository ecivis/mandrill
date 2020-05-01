component extends="testbox.system.BaseSpec" {

    public function run() {

        variables.config = {
            "liveTest": false,
            "apiKey": getApiKey(),
            "authDomain": getAuthDomain()
        };
        if (len(variables.config.apiKey) > 0 && len(variables.config.authDomain) > 0) {
            variables.config.liveTest = true;
        }

        // Force non-live tests, even when configuration values exists
        // variables.config.liveTest = false;

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

                expect(structKeyExists(result, "username")).toBeTrue();
                expect(structKeyExists(result, "stats")).toBeTrue();
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
                    "subject": "Test Email - Basic Message",
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

                expect(arrayLen(result)).toBe(1);
                expect(result[1].status).toBe("sent");
                expect(result[1].email).toBe("recipient@domain.tld");
            });

            it("should be able to send a message with CC and BCC recipients", function () {
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
                    "html": "<p>This is a test email with CC and BCC recipients.</p>",
                    "subject": "Test Email - CC and BCC Recipients",
                    "from_email": "sender@#variables.config.authDomain#",
                    "from_name": "Test Sender",
                    "to": [
                        {
                            "email": "recipient@domain.tld",
                            "name": "Test Recipient"
                        },
                        {
                            "email": "cc@domain.tld",
                            "name": "Test CC Recipient",
                            "type": "cc"
                        },
                        {
                            "email": "bcc@domain.tld",
                            "name": "Test BCC Recipient",
                            "type": "bcc"
                        },
                    ]
                };

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.messages.send(message=message);

                debug(result);

                expect(arrayLen(result)).toBe(3);
                expect(result[1].status).toBe("sent");
                expect(result[1].email).toBe("recipient@domain.tld");
                expect(result[2].status).toBe("sent");
                expect(result[2].email).toBe("cc@domain.tld");
                expect(result[3].status).toBe("sent");
                expect(result[3].email).toBe("bcc@domain.tld");
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

                arrayAppend(template_content, {"name":"header_text", "content":"Test Message Header"});
                arrayAppend(template_content, {"name":"body_text", "content":"<p>This is a test message.</p>"});

                message = {
                    "subject": "Test Email - Template",
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

                expect(arrayLen(result)).toBe(1);
                expect(result[1].status).toBe("sent");
                expect(result[1].email).toBe("recipient@domain.tld");
            });

            it("should be able to send a message using a template using Handlebars", function () {
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

                /*
                When using Handlebars, use global_merge_vars instead of template_content. See below.
                */
                arrayAppend(template_content, {"name":"first_name", "content":"Yourname"});
                arrayAppend(template_content, {"name":"requests", "content":[
                    {
                        "req_title":"Request Title One",
                        "req_description":"This is the description for the first request."
                    },
                    {
                        "req_title":"Request Title Two",
                        "req_description":"This is the description for the second request."
                    }
                ]});

                message = {
                    "subject": "Test Email - Template with Handlebars",
                    "from_email": "sender@#variables.config.authDomain#",
                    "from_name": "Test Sender",
                    "to": [
                        {
                            "email": "recipient@domain.tld",
                            "name": "Test Recipient"
                        }
                    ],
                    "global_merge_vars": template_content,
                    "merge_language": "handlebars"
                };

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.messages.send_template(template_name="handlebars-test", template_content=[], message=message, async=false);

                debug(result);

                expect(arrayLen(result)).toBe(1);
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
                        "email": "blacklisted@domain.tld",
                        "added": true
                    };
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.rejects.add(email="blacklisted@domain.tld");

                debug(result);
            });

            it("should be able to delete a rejected address", function () {
                var mandrill = getMockBox().prepareMock(new mandrill.models.Mandrill());
                var response = [];
                var result = {};

                if (!variables.config.liveTest) {
                    response = {
                        "email": "blacklisted@domain.tld",
                        "deleted": true
                    };
                    variables.mandrillConnector.$(method="makeApiCall", returns=response);
                }

                mandrill.$property(propertyName="mandrillConnector", mock=variables.mandrillConnector);
                result = mandrill.rejects.delete(email="blacklisted@domain.tld");

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
        var sys = createObject("java", "java.lang.System");

        apiKey = sys.getenv("MANDRILL_API_KEY");
        if (!isNull(apiKey) && len(apiKey)) {
            return apiKey;
        }
        apiKey = sys.getProperty("mandrill.api.key");
        if (!isNull(apiKey) && len(apiKey)) {
            return apiKey;
        }
        return "";
    }

    private string function getAuthDomain() {
        var authDomain = "";
        var sys = createObject("java", "java.lang.System");

        authDomain = sys.getenv("MANDRILL_AUTH_DOMAIN");
        if (!isNull(authDomain) && len(authDomain)) {
            return authDomain;
        }
        authDomain = sys.getProperty("mandrill.auth.domain");
        if (!isNull(authDomain) && len(authDomain)) {
            return authDomain;
        }
        return "authorized.tld";
    }

}