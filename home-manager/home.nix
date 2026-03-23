{ config, pkgs, llm-agents, system, ... }:

{
  imports = [
    ./dotfiles.nix
  ];

  home.username = "norikikomori";
  home.homeDirectory = "/Users/norikikomori";
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
    llm-agents.packages.${system}.claude-code
    llm-agents.packages.${system}.codex
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
