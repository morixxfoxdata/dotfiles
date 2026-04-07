{ config, lib, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles/home-manager";
  isDarwin = config.hostSpec.isDarwin;
in
{
  home.activation.linkDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    link_force() {
      local src=$1
      local dst=$2
      $DRY_RUN_CMD mkdir -p "$(dirname "$dst")"
      $DRY_RUN_CMD rm -rf "$dst"
      $DRY_RUN_CMD ln -sf "$src" "$dst"
    }

    # Git
    link_force "${dotfilesDir}/git/.gitconfig" "$HOME/.gitconfig"
    link_force "${dotfilesDir}/git/ignore" "$HOME/.config/git/ignore"

    # Neovim
    link_force "${dotfilesDir}/nvim" "$HOME/.config/nvim"

    # Starship
    link_force "${dotfilesDir}/starship/starship.toml" "$HOME/.config/starship.toml"

    # Zsh
    link_force "${dotfilesDir}/zsh/.zshrc" "$HOME/.zshrc"
    link_force "${dotfilesDir}/zsh/.zshenv" "$HOME/.zshenv"

    # GitHub CLI
    link_force "${dotfilesDir}/gh/config.yml" "$HOME/.config/gh/config.yml"

    # Claude Code
    link_force "${dotfilesDir}/claude/settings.json" "$HOME/.claude/settings.json"
    link_force "${dotfilesDir}/claude/statusline.py" "$HOME/.claude/statusline.py"
    link_force "${dotfilesDir}/claude/rules" "$HOME/.claude/rules"
    link_force "${dotfilesDir}/claude/hooks" "$HOME/.claude/hooks"

    ${lib.optionalString isDarwin ''
    # macOS only
    # Karabiner
    link_force "${dotfilesDir}/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

    # Aerospace
    link_force "${dotfilesDir}/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

    # Ghostty
    link_force "${dotfilesDir}/ghostty/config" "$HOME/.config/ghostty/config"
    ''}
  '';
}
