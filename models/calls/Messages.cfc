component {

    public Messages function init(required mandrill.models.Mandrill mandrill) {
        variables.mandrill = arguments.mandrill;
        return this;
    }

    public array function send(required struct message, boolean async, string ip_pool, string send_at) {
        var payload = {};
        var result = [];

        payload["message"] = arguments.message;
        if (arguments.keyExists("async")) {
            payload["async"] = arguments.async;
        }
        if (arguments.keyExists("ip_pool")) {
            payload["ip_pool"] = arguments.ip_pool;
        }
        if (arguments.keyExists("send_at")) {
            payload["send_at"] = arguments.send_at;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("messages/send", payload);

        return result;
    }

    public array function send_template(required string template_name, required array template_content, required struct message, boolean async, string ip_pool, string send_at) {
        var payload = {};
        var result = [];

        payload["message"] = arguments.message;
        payload["template_name"] = arguments.template_name;
        payload["template_content"] = arguments.template_content;
        if (arguments.keyExists("async")) {
            payload["async"] = arguments.async;
        }
        if (arguments.keyExists("ip_pool")) {
            payload["ip_pool"] = arguments.ip_pool;
        }
        if (arguments.keyExists("send_at")) {
            payload["send_at"] = arguments.send_at;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("messages/send-template", payload);

        return result;
    }

}