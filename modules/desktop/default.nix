{ pkgs, ... }:
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
    age
    difftastic
    neomutt
    notmuch
    isync
    msmtp
    dmenu
    rxvt-unicode
    dunst
    keepassxc
    scrot
    feh
    borgbackup
    git-annex
    gimp
    gh
    rclone
    pavucontrol
    mpv
    lm_sensors
    rtorrent
    slock
    whois
    tmuxPlugins.fzf-tmux-url
    xclip
  ];
  programs.ssh.startAgent = true;
}
