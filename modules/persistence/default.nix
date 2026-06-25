{
  environment.persistence."/persistent" = {
    users.dgrig = {
      directories = [
        "Code"
        "Documents"
        "Vault"
        "Downloads"
        "mail"
        "tmp"
        ".config/io.datasette.llm"
        ".config/gh"
        ".config/ghostty"
        ".config/mozilla"
        ".config/opencode"
        ".config/tridactyl"
        ".ssh"
        ".mbsync"
        ".mutt"
        ".msmtp"
        ".mozilla"
        ".emacs.d"
        ".ollama"
        ".local/share/eva"
        ".local/share/opencode"
      ];
      files = [
        ".tmux.conf"
        ".zshrc"
        ".gitconfig"
        ".histfile"
        ".cache/keepassxc/keepassxc.ini"
        ".config/ls_col"
        ".aliases"
        ".Xdefaults"
        ".xprofile"
        ".mbsyncrc"
        ".muttrc"
        ".msmtprc"
        ".notmuch-config"
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
