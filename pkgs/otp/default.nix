{
  writeShellScriptBin,
  symlinkJoin,
  ...
}:

let
  wrapped = writeShellScriptBin "otp" (builtins.readFile ./otp.sh);
in
symlinkJoin {
  name = "otp";
  paths = [
    wrapped
  ];
}
