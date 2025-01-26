{
  lib,
  rustPlatform,
  ...
}:

rustPlatform.buildRustPackage {
  pname = "udiskie-dmenu";
  version = "0.1.0";

  cargoLock.lockFile = ./Cargo.lock;
  src = lib.cleanSource ./.;
}
