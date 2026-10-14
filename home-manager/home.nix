{ config, lib, pkgs, arto, system, ... }:

let
  zeno-zsh = pkgs.callPackage ./packages/zeno-zsh.nix {};
  herdr = pkgs.callPackage ./packages/herdr.nix {};

  # nixpkgs' nvtop only looks for NVML in /run/opengl-driver/lib (NixOS).
  # On Ubuntu, expose just the host's libnvidia-ml.so.1 so other libs stay
  # resolved from the Nix store.
  nvtop =
    if pkgs.stdenv.hostPlatform.isLinux then
      let
        hostNvml = pkgs.runCommand "host-nvml" {} ''
          mkdir -p $out/lib
          ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 $out/lib/
        '';
      in
      pkgs.symlinkJoin {
        name = "nvtop-host-nvml";
        paths = [ pkgs.nvtopPackages.full ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/nvtop --prefix LD_LIBRARY_PATH : ${hostNvml}/lib
        '';
      }
    else
      pkgs.nvtopPackages.full;

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
    btop
    nvtop
    tree
    poppler-utils
    zoxide
    deno
    zsh-autosuggestions
    zsh-syntax-highlighting
    zeno-zsh
    hunk
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
