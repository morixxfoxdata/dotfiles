# home-manager モジュール: voice2text を launchd で 5 分ごとに実行する
#
# 使い方: 実行したいホストの定義（hosts/*.nix）で imports に追加する
#   hosts/mac-mini.nix で imports = [ ../home-manager/voice2text.nix ];（原本: ~/Developments/projects/voice2text/deploy/voice2text.nix）
{ config, lib, pkgs, ... }:

let
  projectDir = "${config.home.homeDirectory}/Developments/projects/voice2text";
  logDir = "${config.home.homeDirectory}/Library/Logs/voice2text";
in
{
  launchd.agents.voice2text = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/caffeinate" "-i"  # 処理中にスリープしない
        "${pkgs.uv}/bin/uv" "run" "--project" projectDir "v2t" "tick"
      ];
      WorkingDirectory = projectDir;  # .env をここから読み込む
      StartInterval = 300;
      RunAtLoad = true;
      ProcessType = "Background";
      LowPriorityIO = true;
      StandardOutPath = "${logDir}/tick.log";
      StandardErrorPath = "${logDir}/tick.log";
      EnvironmentVariables = {
        PATH = "${pkgs.uv}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        PYTHONUNBUFFERED = "1";
      };
    };
  };

  # GNU rsync（macOS 標準の openrsync はサーバー側の rrsync に拒否される）。config.toml の rsync でこのパスを指す
  home.packages = [ pkgs.rsync ];

  home.activation.voice2textLogDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${logDir}"
  '';
}
