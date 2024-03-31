{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    curl
    dig
    dmidecode
    git
    hdparm
    htop
    killall
    lshw
    lsof
    molly-guard
    pstree
    tmux
    vim
    wget
    zsh
  ];

  users.users.dgrig = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = pkgs.zsh;
}
