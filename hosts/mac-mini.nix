{ ... }:

{
  # 議事録自動生成（voice2text）の定期実行は、常時稼働のこの Mac だけで行う
  imports = [ ../home-manager/voice2text.nix ];

  hostSpec = {
    hostName = "mac-mini";
    username = "komori";
    homeDirectory = "/Users/komori";
    system = "aarch64-darwin";
    isDarwin = true;
  };
}
