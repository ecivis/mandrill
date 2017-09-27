component {

    property name="log" inject="logbox:logger:{this}";

    /**
    * The constructor will configure itself with the calls it supports.
    */
    public Mandrill function init() {
        this.users = new mandrill.calls.Users(this);
        this.messages = new mandrill.calls.Messages(this);
        this.rejects = new mandrill.calls.Rejects(this);
        this.whitelists = new mandrill.calls.Whitelists(this);

        return this;
    }

    public MandrillConnector function getMandrillConnector() {
        if (variables.keyExists("mandrillConnector")) {
            return variables.mandrillConnector;
        }
        throw(type="MandrillConfigurationException", message="The Mandrill instance does not have a properly configurated MandrillConnector.");
    }

    public void function setMandrillConnector(required MandrillConnector mandrillConnector) {
        variables.mandrillConnector = arguments.mandrillConnector;
    }

}