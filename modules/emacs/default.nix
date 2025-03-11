{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor pkgs.emacs-nox).emacsWithPackages (epkgs: [
      epkgs.evil
      epkgs.evil-collection
      epkgs.evil-leader
      epkgs.monokai-theme
      epkgs.nix-mode
      epkgs.org-re-reveal
      epkgs.org-roam
      epkgs.org-contacts
      epkgs.projectile
      epkgs.rust-mode
      epkgs.terraform-mode
    ]))
  ];
}
