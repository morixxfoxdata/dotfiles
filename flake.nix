{
  description = "Home Manager configuration of norikikomori";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    { nixpkgs, home-manager, llm-agents, ... }:
    let
      # ホスト定義: 新しいマシンを追加する場合はここにエントリを追加
      hosts = {
        NorikinoMacBook-Pro = {
          system = "aarch64-darwin";
          hostModule = ./hosts/mbp.nix;
        };
        gpu-server = {
          system = "x86_64-linux";
          hostModule = ./hosts/gpu-server.nix;
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
          extraSpecialArgs = { inherit llm-agents system; };
        };

      # 全ホスト共通の system リスト (flake apps 用)
      allSystems = nixpkgs.lib.unique (nixpkgs.lib.mapAttrsToList (_: h: h.system) hosts);
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs mkHomeConfiguration hosts;

      # Flake apps: nix run .#switch, nix run .#update
      apps = nixpkgs.lib.genAttrs allSystems (system: {
        switch = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "switch" ''
            hostname=$(hostname -s)
            echo "Switching Home Manager configuration for: $hostname"
            home-manager switch --flake "${builtins.toString ./.}#$hostname" "$@"
          '');
        };
        update = {
          type = "app";
          program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "update" ''
            hostname=$(hostname -s)
            echo "Updating flake inputs..."
            nix flake update
            echo "Switching Home Manager configuration for: $hostname"
            home-manager switch --flake "${builtins.toString ./.}#$hostname" "$@"
          '');
        };
      });
    };
}
