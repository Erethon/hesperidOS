{ pkgs, lib, ... }:
let
  custom_terminus = pkgs.terminus_font.overrideAttrs (
    _: _: {
      patches = [
        "alt/td1.diff"
        "alt/dv1.diff"
        "alt/ij1.diff"
      ];
    }
  );
in
{
  services = {
    opensnitch.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us,gr,ru";
        variant = ",,phonetic";
        options = "grp:alt_shift_toggle,ctrl:nocaps";
      };
      windowManager = {
        dwm.enable = true;
        dwm.package = pkgs.dwm.override { conf = ../../patches/dwm-config.h; };
      };
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
      KERNEL=="uhid", SUBSYSTEM=="misc", GROUP="tss", MODE="0660"
    '';

    pipewire.extraConfig.pipewire."00-disable-bell" = {
      "context.properties" = {
        "module.x11.bell" = "false";
      };
    };
  };
  fonts.packages = [ custom_terminus ];

  environment.systemPackages = with pkgs; [
    (llm.withPlugins { llm-openai-plugin = true; })
    age
    borgbackup
    difftastic
    dmenu
    dunst
    exiftool
    feh
    files-to-prompt
    gh
    ghostty
    gimp
    git-annex
    hydra-check
    isync
    jq
    keepassxc
    lm_sensors
    mplayer
    mpv
    msmtp
    neomutt
    netdiscover
    newsboat
    nh
    nix-output-monitor
    nmap
    notmuch
    opensnitch-ui
    pavucontrol
    rclone
    rtorrent
    scrot
    slock
    tmuxPlugins.fzf-tmux-url
    ungoogled-chromium
    whois
    xclip
    xdotool
  ];

  programs = {
    ssh.startAgent = true;
    slock.enable = true;
  };

  documentation.enable = lib.mkForce true;
  security.sudo.wheelNeedsPassword = lib.mkForce true;
  users.users.dgrig.extraGroups = [ "dialout" ];
}
