{ config, pkgs, llm-agents, nix-claude-code, arto, system, ... }:

let
  zeno-zsh = pkgs.callPackage ./packages/zeno-zsh.nix {};
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
    nix-claude-code.packages.${system}.default
    llm-agents.packages.${system}.codex
    llm-agents.packages.${system}.gemini-cli
    arto.packages.${system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
