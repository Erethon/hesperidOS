{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    curl
    dig
    dmidecode
    file
    git
    hdparm
    htop
    killall
    lshw
    lsof
    molly-guard
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
