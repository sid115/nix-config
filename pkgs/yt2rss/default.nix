{
  writeShellScriptBin,
  symlinkJoin,
  ...
}:

let
  wrapped = writeShellScriptBin "yt2rss" (builtins.readFile ./yt2rss.sh);
in
symlinkJoin {
  name = "create";
  paths = [
    wrapped
  ];
}
