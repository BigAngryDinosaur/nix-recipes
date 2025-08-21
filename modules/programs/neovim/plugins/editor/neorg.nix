{
    enable = true;
    settings = {
        lazy_loading = true;
        load = {
            "core.concealer" = {
                config = {
                    icon_preset = "varied";
                };
            };
            "core.defaults" = {
                __empty = null;
            };
            "core.dirman" = {
                config = {
                    workspaces = {
                        home = "~/notes/home";
                    };
                };
            };
            "core.integrations.telescope" = {
                __empty = null;
            };
        };
    };
    telescopeIntegration = {
        enable = true;
    };
}
