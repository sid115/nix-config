{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
}:

buildNpmPackage rec {
  pname = "open-webui-desktop";
  version = "7e54042";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "desktop";
    rev = "build-e${version}";
    hash = "sha256-eW3B8CS2T46Z91JRAlZJ3rNxAru4p7eJwyxn6P20pnA=";
  };

  npmDepsHash = "sha256-HdkgbcLzY/9T26hpw6Jej8sUWlcIIn1FkJ7IVvG3P4o=";

  makeCacheWritable = true;

  # Create .npmrc to prevent scripts from running during install
  postPatch = ''
    cat >> .npmrc << 'EOF'
    ignore-scripts=true
    EOF
  '';

  preInstall = ''
    sed -i '/postinstall/d' package.json
  '';

  npmRebuild = false;

  buildPhase = ''
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
    npm run build
  '';

  installPhase = ''
    mkdir -p $out/opt/${pname}
    cp -r out $out/opt/${pname}/
    cp -r resources $out/opt/${pname}/
    cp -r node_modules $out/opt/${pname}/
    mkdir -p $out/bin

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags "$out/opt/${pname}/out/main/index.js" \
      --run "cd $out/opt/${pname}"
  '';

  meta = {
    description = "Open WebUI Desktop 🌐 (Alpha)";
    homepage = "https://github.com/open-webui/desktop";
    # license = lib.licenses.TODO;
    mainProgram = "open-webui-desktop";
    platforms = lib.platforms.linux;
  };
}
