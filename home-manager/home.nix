{ config, lib, pkgs, arto, system, ... }:

let
  zeno-zsh = pkgs.callPackage ./packages/zeno-zsh.nix {};
  difit = pkgs.callPackage ./packages/difit {};
  herdr = pkgs.callPackage ./packages/herdr.nix {};

  # Herdr plugins to keep installed. Clones/builds live under
  # ~/.config/herdr/plugins and are managed by herdr itself.
  herdrPlugins = [
    { id = "herdr-file-viewer"; source = "smarzban/herdr-file-viewer"; }
  ];
in
{
  imports = [
    ./dotfiles.nix
  ];

  home.username = config.hostSpec.username;
  home.homeDirectory = config.hostSpec.homeDirectory;
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    git
    ripgrep
    fzf
    gh
    lazygit
    yazi
    uv
    mise
    neovim
    starship
    nodejs
    google-cloud-sdk
    rustup
    eza
    zoxide
    deno
    zsh-autosuggestions
    zsh-syntax-highlighting
    zeno-zsh
    difit
    herdr
    arto.packages.${system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.activation.herdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStrings (p: ''
      if ! ${herdr}/bin/herdr plugin list --json 2>/dev/null | grep -q '"plugin_id":"${p.id}"'; then
        $DRY_RUN_CMD ${herdr}/bin/herdr plugin install ${p.source} --yes \
          || echo "warning: herdr plugin install ${p.source} failed (offline?)" >&2
      fi
    '') herdrPlugins
  );

  programs.home-manager.enable = true;
}
