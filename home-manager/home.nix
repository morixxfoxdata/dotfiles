{ config, pkgs, arto, system, ... }:

let
  zeno-zsh = pkgs.callPackage ./packages/zeno-zsh.nix {};
  difit = pkgs.callPackage ./packages/difit {};
  herdr = pkgs.callPackage ./packages/herdr.nix {};
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

  programs.home-manager.enable = true;
}
