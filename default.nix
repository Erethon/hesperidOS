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
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPb9z1U7Sti2lls0mlcmyPwmwD91amKwVlLZHYclSoULAAAABHNzaDo="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBg4C7jOGuVMxSvUlGaZXf0JD/jag//1kFl5okKhjQhF"
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;

  networking.firewall.enable = true;

  services.openssh.enable = true;
}
