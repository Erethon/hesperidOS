{ pkgs, ... }: {
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us,gr,ru";
    xkb.variant = ",,phonetic";
    xkb.options = "grp:alt_shift_toggle,ctrl:nocaps";
    libinput.enable = true;
    windowManager.dwm.enable = true;
    windowManager.dwm.package =
      pkgs.dwm.override { conf = ../../patches/dwm-config.h; };
  };

  services.opensnitch.enable = true;
  environment.systemPackages = with pkgs; [ opensnitch-ui ];
  programs.ssh.startAgent = true;
  users.users.dgrig.extraGroups = [ "wheel" "video" ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
}
