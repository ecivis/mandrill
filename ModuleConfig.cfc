component {

    this.title  = "Mandrill";
    this.author = "Joseph Lamoree";
    this.webURL = "https://github.com/ecivis/mandrill";
    this.description = "An interface to the Mandrill API.";
    this.version = "0.0.1";
    this.dependencies = [];
    this.autoMapModels = false;

    /**
    * Configure
    */
    public void function configure() {
        var userSettings = variables.controller.getSetting(name="mandrill", fwSetting=false, defaultValue={});

        variables.settings = {
            "apiKey" = userSettings.keyExists("apiKey") ? userSettings.apiKey : "",
            "endpointBaseUrl" = userSettings.keyExists("endpointBaseUrl") ? userSettings.endpointBaseUrl : ""
        };
    }

    /**
    * Fired when the module is registered and activated.
    */
    public void function onLoad() {
        variables.binder.map("mandrillConnector")
            .to("mandrill.MandrillConnector")
            .initArg(name="apiKey", value=variables.settings.apiKey)
            .initArg(name="endpointBaseUrl", value=variables.settings.endpointBaseUrl)
            .asSingleton();

        variables.binder.map("mandrillClient")
            .to("mandrill.Mandrill")
            .withInfluence(function (injector, object, instance) {
                instance.setMandrillConnector(injector.getInstance("mandrillConnector"));
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