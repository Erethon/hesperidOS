{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      ((emacsPackagesFor pkgs.emacs29-nox).emacsWithPackages (epkgs: [
        epkgs.evil
        epkgs.evil-collection
        epkgs.evil-leader
        epkgs.monokai-theme
        epkgs.nix-mode
        epkgs.org-journal
        epkgs.projectile
      ]))
    ];

  services.emacs = { enable = true; };
}
