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
      # Needed for USB gadgets and printing
      # "dialout"
      # "lp"
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
    settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [ "dgrig" ];
    };
    optimise.automatic = true;
  };
  services = {
    openssh = {
      enable = true;
      ports = [ 222 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = lib.mkForce "no";
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
      MIICCTCCAa+gAwIBAgIRANbTaHFEx7Zxj/1vQdt1x80wCgYIKoZIzj0EAwIwMjET
      MBEGA1UEChMKRXJldGhvbiBDQTEbMBkGA1UEAxMSRXJldGhvbiBDQSBSb290IENB
      MB4XDTI2MDEyODEzMDUyOVoXDTI3MDEyODEzMDUyOFowIjEgMB4GA1UEAxMXRXJl
      dGhvbiBJbnRlcm1lZGlhdGUgQ0EwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAR2
      6Kp5br9aXgA7H2Z5UrJnDZx6Q9WffrYhOhM1Z+Uk52olDRmcXWCg0DZFGUhYFoI5
      l/WJATvzfvEZ8/KvgxsAo4G1MIGyMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8E
      CDAGAQH/AgEAMB0GA1UdDgQWBBQOQTGYsWTOGBfa5Hx6Wg4UCdEEnjAfBgNVHSME
      GDAWgBQlc3sO0n/lxGKaDFc2AKWcQ7momTBMBgNVHR4BAf8EQjBAoD4wDIIKdHMu
      ZXJldGhvbjAOggxob21lLmVyZXRob24wDYILLnRzLmVyZXRob24wD4INLmhvbWUu
      ZXJldGhvbjAKBggqhkjOPQQDAgNIADBFAiA+BV1ziSjQ35w7GOYsfrt5+pfIYwYy
      OVxCjsBZODheNAIhAMWpj8i9XAnwBxMYtmt9WdFf7M0/aJlEiqfzqfq70RA6
      -----END CERTIFICATE-----
    ''
  ];

  documentation.doc.enable = false;
}
