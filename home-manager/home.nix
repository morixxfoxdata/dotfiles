{ config, pkgs, llm-agents, system, ... }:

{
  imports = [
    ./dotfiles.nix
  ];

  home.username = config.hostSpec.username;
  home.homeDirectory = config.hostSpec.homeDirectory;
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    git
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
    zsh-autosuggestions
    zsh-syntax-highlighting
    llm-agents.packages.${system}.claude-code
    llm-agents.packages.${system}.codex
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
