component {

    public Rejects function init(required mandrill.models.Mandrill mandrill) {
        variables.mandrill = arguments.mandrill;
        return this;
    }

    public array function list(string email, boolean include_expired, string subaccount) {
        var payload = {};
        var result = {};

        if (structKeyExists(arguments, "email")) {
            payload["email"] = arguments.email;
        }
        if (structKeyExists(arguments, "include_expired")) {
            payload["include_expired"] = arguments.include_expired;
        }
        if (structKeyExists(arguments, "subaccount")) {
            payload["subaccount"] = arguments.subaccount;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("rejects/list", payload);

        return result;
    }

    public struct function add(required string email, string comment, string subaccount) {
        var payload = {};
        var result = {};

        payload["email"] = arguments.email;
        if (structKeyExists(arguments, "comment")) {
            payload["comment"] = arguments.comment;
        }
        if (structKeyExists(arguments, "subaccount")) {
            payload["subaccount"] = arguments.subaccount;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("rejects/add", payload);

        return result;
    }

    public struct function delete(required string email, string subaccount) {
        var payload = {};
        var result = {};

        payload["email"] = arguments.email;
        if (structKeyExists(arguments, "subaccount")) {
            payload["subaccount"] = arguments.subaccount;
        }

        result = variables.mandrill.getMandrillConnector().makeApiCall("rejects/delete", payload);

        return result;
    }


}