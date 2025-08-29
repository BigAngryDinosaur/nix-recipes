{ config, ... }: {

    imports = [
        ./git
        ./jj
    ];

    config = {
        git.enable = true;
        jj.enable = true;
    };
}
