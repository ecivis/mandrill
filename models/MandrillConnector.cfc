component {

    property name="log" inject="logbox:logger:{this}";

    /**
    * @endpointBaseUrl The default will work, but a newer version may be desired in the future.
    * @apiKey Any valid API key.
    */
    public MandrillConnector function init(string endpointBaseUrl, string apiKey) {
        variables.endpointBaseUrl = arguments.keyExists("endpointBaseUrl") ? arguments.endpointBaseUrl : "https://mandrillapp.com/api/1.0/";
        variables.apiKey = arguments.keyExists("apiKey") ? arguments.apiKey : "";

        if (right(variables.endpointBaseUrl, 1) != "/") {
            variables.endpointBaseUrl = variables.endpointBaseUrl & "/";
        }

        return this;
    }

    /**
    * This is the function that does the work of communicating with Mandrill, regardless of the endpoint. It should be generic enough to handle all situations
    * and doesn't care too much about the content flowing through it.
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

        _payload["key"] = variables.apiKey;

        try {
            req = new Http(method="POST", url=endpoint);
            req.addParam(type="header", name="Content-Type", value="application/json");
            req.addParam(type="body", value="#serializeJson(_payload)#");

            resp = req.send().getPrefix();
        } catch (Exception e) {
            error = "The HTTP call to #endpoint# failed.";
            if (e.keyExists("message")) {
                error = error & " " & e.message;
            }
            if (e.keyExists("detail")) {
                error = error & " " & e.detail;
            }
            throw(type="HttpException", message=error);
        }

        if (!resp.keyExists("fileContent") || len(resp.fileContent) == 0) {
            throw(type="ApiResponseException", message="The Mandrill API did not return content.");
        }

        try {
            result = deserializeJSON(resp.fileContent);
        } catch (Exception e) {
            error = "The JSON response from Mandrill could not be parsed.";
            if (e.keyExists("message")) {
                error = error & " " & e.message;
            }
            if (e.keyExists("detail")) {
                error = error & " " & e.detail;
            }
            throw(type="InvalidJsonException", message=error);
        }

        if (isStruct(result) && result.keyExists("status") && result.status == "error") {
            if (result.keyExists("message")) {
                error = "The Mandrill API returned an error: #result.message#";
            } else {
                error = "The Mandrill API returned an error."
            }
            throw(type="ApiErrorException", message="The Mandrill API returned an error");
        }

        return result;
    }

}