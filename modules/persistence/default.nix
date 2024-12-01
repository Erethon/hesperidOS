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
        ".ssh"
        ".mbsync"
        ".mutt"
        ".msmtp"
        ".mozilla"
        ".emacs.d"
        ".ollama"
      ];
      files = [
        ".tmux.conf"
        ".zshrc"
        ".gitconfig"
        ".histfile"
        ".config/ls_col"
        ".aliases"
        ".Xdefaults"
        ".xprofile"
        ".mbsyncrc"
        ".muttrc"
        ".msmtprc"
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
