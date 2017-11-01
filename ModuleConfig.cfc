component {

    this.title  = "Mandrill";
    this.author = "Joseph Lamoree";
    this.webURL = "https://github.com/ecivis/mandrill";
    this.description = "An interface to the Mandrill API.";
    this.version = "0.0.2";
    this.dependencies = [];
    this.autoMapModels = false;
    this.cfmapping = "mandrill";

    /**
    * Configure
    */
    public void function configure() {
        variables.settings = {
            "apiKey": "",               // A valid Mandrill API key is required to use the service.
            "endpointBaseUrl": ""       // This is optional. The connector will use its default if not overridden.
        };
    }

    /**
    * Fired when the module is registered and activated.
    */
    public void function onLoad() {
        variables.binder.map("mandrillConnector@mandrill")
            .to("mandrill.models.MandrillConnector")
            .initArg(name="apiKey", value=variables.settings.apiKey)
            .initArg(name="endpointBaseUrl", value=variables.settings.endpointBaseUrl)
            .asSingleton();

        variables.binder.map("mandrillClient@mandrill")
            .to("mandrill.models.Mandrill")
            .withInfluence(function (injector, object, instance) {
                instance.setMandrillConnector(injector.getInstance("mandrillConnector@mandrill"));
                return instance;
            })
            .asSingleton();
    }

    /**
    * Fired when the module is unregistered and unloaded
    */
    public void function onUnload() {
    }

}