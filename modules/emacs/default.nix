{ pkgs, ... }:
let
  emacsPkgs = (pkgs.emacsPackagesFor pkgs.emacs-nox).overrideScope (
    _final: prev: {
      monokai-theme = prev.monokai-theme.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./patches/emacs-monokai.patch ];
      });
    }
  );
in
{
  environment.systemPackages = [
    (emacsPkgs.emacsWithPackages (epkgs: [
      epkgs.evil
      epkgs.evil-collection
      epkgs.evil-leader
      epkgs.monokai-theme
      epkgs.nix-mode
      epkgs.notmuch
      #epkgs.org-caldav
      epkgs.org-contacts
      epkgs.org-re-reveal
      epkgs.org-roam
      epkgs.projectile
      epkgs.rust-mode
      epkgs.terraform-mode
    ]))
  ];
}
