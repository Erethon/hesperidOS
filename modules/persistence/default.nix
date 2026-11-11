{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  environment.persistence."/persistent" = {
    directories =  [ "/var/lib/nixos" ];
    users.dgrig = {
      directories = [
        "Code"
      ];
      files = [
        ".tmux.conf"
        ".zshrc"
        ".gitconfig"
        ".histfile"
        ".aliases"
        ".vimrc"
      ];
    };
  };

  fileSystems."/home/dgrig" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=4G"
      "mode=700"
    ];
    neededForBoot = true;
  };
}
