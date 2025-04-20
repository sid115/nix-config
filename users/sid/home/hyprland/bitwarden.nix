{ inputs, pkgs, ... }:

let
  pass2csv =
    {
      lib,
      python3,
      fetchFromGitea,
    }:

    python3.pkgs.buildPythonApplication rec {
      pname = "pass2csv";
      version = "1.2.0";
      pyproject = true;

      src = fetchFromGitea {
        domain = "codeberg.org";
        owner = "svartstare";
        repo = "pass2csv";
        rev = "v${version}";
        hash = "sha256-AzhKSfuwIcw/iizizuemht46x8mKyBFYjfRv9Qczr6s=";
      };

      build-system = [
        python3.pkgs.setuptools
      ];

      dependencies = with python3.pkgs; [
        python-gnupg
      ];

      pythonImportsCheck = [
        "pass2csv"
      ];

      meta = {
        description = "Export passwords from pass to CSV";
        homepage = "https://codeberg.org/svartstare/pass2csv";
        license = lib.licenses.mit;
        mainProgram = "pass2csv";
      };
    };
in
{
  home.packages = with pkgs; [
    bitwarden-cli
    bitwarden-desktop
    bitwarden-menu
    (callPackage pass2csv { })
  ];

  programs.librewolf.profiles.default.extensions =
    with inputs.nur.legacyPackages."${pkgs.system}".repos.rycee.firefox-addons; [
      bitwarden
    ];
}
