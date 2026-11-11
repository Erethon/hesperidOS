{ lib, options, ... }:
{
  config = lib.optionalAttrs (options.environment ? persistence) {
    environment.persistence."/persistent" = {
      users.dgrig = {
        directories = [
          "Documents"
          "Downloads"
          "Vault"
          "mail"
          "Sessions"
          "tmp"
          ".cache/huggingface"
          ".config/io.datasette.llm"
          ".config/gh"
          ".config/ghostty"
          ".config/mozilla"
          ".config/tridactyl"
          ".ssh"
          ".mbsync"
          ".mutt"
          ".msmtp"
          ".mozilla"
          ".emacs.d"
          ".ollama"
          ".local/share/eva"
          ".local/state/wireplumber"
          ".newsboat"
        ];
        files = [
          ".cache/keepassxc/keepassxc.ini"
          ".config/ls_col"
          ".Xdefaults"
          ".xprofile"
          ".mailcap"
          ".mbsyncrc"
          ".muttrc"
          ".msmtprc"
          ".notmuch-config"
        ];
      };
    };
  };
}
