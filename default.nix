{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    bc
    btop
    curl
    dig
    dmidecode
    file
    git
    hdparm
    htop
    iotop
    killall
    lshw
    lsof
    molly-guard
    nmon
    pstree
    tmux
    tree
    vim
    wget
    zsh
  ];

  users.users.dgrig = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = pkgs.zsh;

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;

  networking.firewall.enable = true;

  services.openssh.enable = true;
}
