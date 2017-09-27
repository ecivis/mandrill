component {

    public Users function init(required mandrill.Mandrill mandrill) {
        variables.mandrill = arguments.mandrill;
        return this;
    }

    public struct function info() {
        var payload = {};
        var result = {};

        result = variables.mandrill.getMandrillConnector().makeApiCall("users/info", payload);

        return result;
    }

}