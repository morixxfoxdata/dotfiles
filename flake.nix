{
  description = "Home Manager configuration of norikikomori";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    nix-claude-code.url = "github:ryoppippi/nix-claude-code";
    arto.url = "github:arto-app/Arto";
  };

  outputs =
    { nixpkgs, home-manager, llm-agents, nix-claude-code, arto, ... }:
    let
      # ホスト定義: 新しいマシンを追加する場合はここにエントリを追加
      hosts = {
        NorikinoMacBook-Pro = {
          system = "aarch64-darwin";
          hostModule = ./hosts/mbp.nix;
        };
        gansan = {
          system = "x86_64-linux";
          hostModule = ./hosts/gansan.nix;
        };
        Mac-mini = {
          system = "aarch64-darwin";
          hostModule = ./hosts/mac-mini.nix;
        };
      };

      mkHomeConfiguration =
        name:
        { system, hostModule }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/default.nix
            hostModule
            ./home-manager/home.nix
          ];
          extraSpecialArgs = { inherit llm-agents nix-claude-code arto system; };
        };

      # 全ホスト共通の system リスト (flake apps 用)
      allSystems = nixpkgs.lib.unique (nixpkgs.lib.mapAttrsToList (_: h: h.system) hosts);
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs mkHomeConfiguration hosts;

      # Flake apps: nix run .#switch, nix run .#update
      apps = nixpkgs.lib.genAttrs allSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hm = home-manager.packages.${system}.home-manager;
        in
        {
          switch = {
            type = "app";
            program = toString (pkgs.writeShellScript "switch" ''
              FLAKE_DIR="''${FLAKE_DIR:-$HOME/dotfiles}"
              hostname=$(hostname -s)
              echo "Switching Home Manager configuration for: $hostname"
              ${hm}/bin/home-manager switch --flake "$FLAKE_DIR#$hostname" "$@"
            '');
          };
          update = {
            type = "app";
            program = toString (pkgs.writeShellScript "update" ''
              FLAKE_DIR="''${FLAKE_DIR:-$HOME/dotfiles}"
              hostname=$(hostname -s)
              echo "Updating flake inputs..."
              nix flake update "$FLAKE_DIR"
              echo "Switching Home Manager configuration for: $hostname"
              ${hm}/bin/home-manager switch --flake "$FLAKE_DIR#$hostname" "$@"
            '');
          };
        }
      );
    };
}
