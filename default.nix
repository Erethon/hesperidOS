{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    bc
    btop
    curl
    dig
    dmidecode
    fd
    file
    fzf
    git
    hdparm
    htop
    iotop
    killall
    lshw
    lsof
    molly-guard
    ncdu
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
    initialPassword = "vmonlypass";
  };
  users.defaultUserShell = pkgs.zsh;

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;

  networking.firewall.enable = true;

  services.openssh.enable = true;
}
