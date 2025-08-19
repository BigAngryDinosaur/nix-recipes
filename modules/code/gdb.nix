{ config, userSettings, ... }: {
    
    home-manager.users.${userSettings.username} = {
        home.file.".gdbinit".text = ''
            set disassembly-flavor intel
        '';
    };
}
