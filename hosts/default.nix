{ lib, ... }:

{
  options.hostSpec = {
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "ホスト名";
    };
    username = lib.mkOption {
      type = lib.types.str;
      description = "ユーザー名";
    };
    homeDirectory = lib.mkOption {
      type = lib.types.str;
      description = "ホームディレクトリのパス";
    };
    system = lib.mkOption {
      type = lib.types.str;
      description = "システムアーキテクチャ (e.g. aarch64-darwin, x86_64-linux)";
    };
    isDarwin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "macOS かどうか";
    };
  };
}
