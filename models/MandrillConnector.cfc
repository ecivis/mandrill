component {

    property name="log" inject="logbox:logger:{this}";

    /**
    * The MandrillConnector retains configuration information. A reference is kept in the Mandrill client.
    * @endpointBaseUrl The default will work, but a newer version may be desired in the future.
    * @apiKey Any valid API key.
    */
    public MandrillConnector function init(string endpointBaseUrl, string apiKey) {
        variables.endpointBaseUrl = structKeyExists(arguments, "endpointBaseUrl") && len(arguments.endpointBaseUrl) ? arguments.endpointBaseUrl : "https://mandrillapp.com/api/1.0/";
        variables.apiKey = structKeyExists(arguments, "apiKey") ? arguments.apiKey : "";

        if (right(variables.endpointBaseUrl, 1) != "/") {
            variables.endpointBaseUrl = variables.endpointBaseUrl & "/";
        }

        return this;
    }

    /**
    * This is the function that does the work of communicating with Mandrill, regardless of the endpoint. It should be generic enough to handle all situations
    * and doesn't care too much about the content flowing through it, except that it's parsable JSON.
    */
    public any function makeAPICall(required string restPath, required struct payload) {
        var req = "null";
        var resp = "null";
        var endpoint = variables.endpointBaseUrl & arguments.restPath;
        var _payload = duplicate(arguments.payload); // Make a copy so we don't inject our API key into the caller's payload
        var result = {};
        var error = "";

        // Prevent accidental double slashes when endpointBaseUrl ends in a slash and restPath starts with a slash.
        if (reFind("[^:]//+", endpoint) > 0) {
            endpoint = reReplace(endpoint, "([^:])//+", "\1/", "all");
        }

        // Do not attempt to use the Mandrill API without an API key; the result would be a hard 500 HTTP response
        if (len(variables.apiKey) == 0) {
            throw(type="ConfigException", message="The Mandrill module does not have an API key defined. A request will not be made.");
        }

        _payload["key"] = variables.apiKey;

        try {
            if (structKeyExists(variables, "log") && variables.log.canDebug()) {
                variables.log.debug("Calling #endpoint#");
            }

            req = new Http(method="POST", url=endpoint, throwOnError=true);
            req.addParam(type="header", name="Content-Type", value="application/json");
            req.addParam(type="body", value="#serializeJson(_payload)#");

            resp = req.send().getPrefix();
        } catch (any e) {
            error = "The HTTP call to #endpoint# failed.";

            if (structKeyExists(e, "message")) {
                if (e.message == "500 Internal Server Error") {
                    error = error & " It is very likely that the Mandril API key is incorrect.";
                } else {
                    error = error & " " & e.message;
                }
            }
            if (structKeyExists(e, "detail")) {
                error = error & " " & e.detail;
            }
            if (structKeyExists(variables, "log") && variables.log.canError()) {
                variables.log.error(error);
            }
            throw(type="HttpException", message=error);
        }

        if (!structKeyExists(resp, "statusCode")) {
            error = "The HTTP response does not contain a statusCode.";
            if (structKeyExists(variables, "log") && variables.log.canError()) {
                variables.log.error(error);
            }
            throw(type="HttpException", message=error);
        }

        if (reFind("^200", resp.statusCode) == 0) {
            error = "The Mandrill API returned status '#resp.statusCode#'.";
            if (structKeyExists(variables, "log") && variables.log.canError()) {
                variables.log.error(error);
            }
            throw(type="ApiResponseException", message=error);
        }

        if (!structKeyExists(resp, "fileContent") || len(resp.fileContent) == 0) {
            error = "The Mandrill API did not return content.";
            if (structKeyExists(variables, "log") && variables.log.canError()) {
                variables.log.error(error);
            }
            throw(type="ApiResponseException", message=error);
        }

        try {
            result = deserializeJSON(resp.fileContent);
        } catch (any e) {
            error = "The JSON response from Mandrill could not be parsed.";
            if (structKeyExists(e, "message")) {
                error = error & " " & e.message;
            }
            if (structKeyExists(e, "detail")) {
                error = error & " " & e.detail;
            }
            if (structKeyExists(variables, "log") && variables.log.canError()) {
                variables.log.error(error);
            }
            throw(type="InvalidJsonException", message=error);
        }

        if (isStruct(result) && structKeyExists(result, "status") && result.status == "error") {
            if (structKeyExists(result, "message")) {
                error = "The Mandrill API returned an error: #result.message#";
            } else {
                error = "The Mandrill API returned an error.";
            }
            if (structKeyExists(variables, "log") && variables.log.canError()) {
                variables.log.error(error);
            }
            throw(type="ApiErrorException", message="The Mandrill API returned an error");
        }

        return result;
    }

}