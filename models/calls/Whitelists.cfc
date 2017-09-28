component {

    public Whitelists function init(required mandrill.models.Mandrill mandrill) {
        variables.mandrill = arguments.mandrill;
        return this;
    }

    public array function list(string email) {
        var payload = {};
        var result = {};

        if (arguments.keyExists("email")) {
            payload["email"] = arguments.email;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("whitelists/list", payload);

        return result;
    }

    public struct function add(required string email, string comment) {
        var payload = {};
        var result = {};

        payload["email"] = arguments.email;
        if (arguments.keyExists("comment")) {
            payload["comment"] = arguments.comment;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("whitelists/add", payload);

        return result;
    }

    public struct function delete(required string email) {
        var payload = {};
        var result = {};

        payload["email"] = arguments.email;
        if (arguments.keyExists("subaccount")) {
            payload["subaccount"] = arguments.subaccount;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("whitelists/delete", payload);

        return result;
    }


}