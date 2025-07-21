{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    dig
    dool
    dust
    dysk
    eva
    fd
    file
    fzf
    git
    htop
    iotop
    killall
    lsof
    molly-guard
    ncdu
    nmon
    psmisc
    procs
    tmux
    tree
    vim
    wget
    whois
    zsh
  ];

  users.users.dgrig = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "plugdev"
    ];
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

  nix = {
    package = pkgs.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise.automatic = true;
  };
  services = {
    openssh = {
      enable = true;
      ports = [ 222 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = lib.mkDefault "no";
      };
    };
    locate.enable = true;
    speechd.enable = false;
  };
  security.pki.certificates = [
    ''
          ts.erethon
          ==========
      -----BEGIN CERTIFICATE-----
      MIIB8zCCAZmgAwIBAgIQeLwQZpngGi1bCAB1SCgWUDAKBggqhkjOPQQDAjA2MRUw
      EwYDVQQKEwxFcmV0aG9uIEFDTUUxHTAbBgNVBAMTFEVyZXRob24gQUNNRSBSb290
      IENBMB4XDTI1MDExNjE3MTMxOFoXDTI2MDExNjE3MTMxM1owKTEnMCUGA1UEAxMe
      RXJldGhvbiBJbnRlcm1lZGlhdGUgQ0EgMSB5ZWFyMFkwEwYHKoZIzj0CAQYIKoZI
      zj0DAQcDQgAE/4x0a1HYvispF/3jxpNzSJG4+rKOVVZfIc8c6+h/kt4Y7H8m5ano
      wxLt2/Zxsq37Cxooh0HSM05stdM6g2i3paOBlTCBkjAOBgNVHQ8BAf8EBAMCAQYw
      EgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUGwXonl+GsbaeD4WMFiJPXhme
      HUMwHwYDVR0jBBgwFoAUtk+xqvw0f1EpCdCt7IArEzfx+V0wLAYDVR0eAQH/BCIw
      IKAeMAyCCnRzLmVyZXRob24wDoIMaG9tZS5lcmV0aG9uMAoGCCqGSM49BAMCA0gA
      MEUCIBxCy915nTjTI8KMOmnR7LsUA2Al/s4BchlRk/t2WFiZAiEA4JAcpMhve27/
      cfGASeMdyf4brBneQYsKfllKTCUDsI4=
      -----END CERTIFICATE-----
    ''
  ];
}
