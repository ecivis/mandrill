component {

    /**
    * The constructor will configure itself with the calls it supports.
    */
    public Mandrill function init() {
        this.users = new mandrill.models.calls.Users(this);
        this.messages = new mandrill.models.calls.Messages(this);
        this.rejects = new mandrill.models.calls.Rejects(this);
        this.whitelists = new mandrill.models.calls.Whitelists(this);

        return this;
    }

    public MandrillConnector function getMandrillConnector() {
        if (structKeyExists(variables, "mandrillConnector")) {
            return variables.mandrillConnector;
        }
        throw(type="MandrillConfigurationException", message="The Mandrill instance does not have a properly configurated MandrillConnector.");
    }

    public void function setMandrillConnector(required MandrillConnector mandrillConnector) {
        variables.mandrillConnector = arguments.mandrillConnector;
    }

}